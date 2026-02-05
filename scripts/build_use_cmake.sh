#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

if [[ $# -lt 2 ]]; then die "参数错误！"; fi

pushd "$(dirname "$0")" >/dev/null

pushd .. >/dev/null
cores_dir="$PWD/cores"
dists_dir="$PWD/cores/dists"
if [[ ! -d $dists_dir ]]; then mkdir -p $dists_dir >/dev/null; die "创建分发目录出错！"; fi
popd >/dev/null

# 使用cmake编译通用方法，参数说明：
# $1 - 内核显示名称
# $2 - 内核名称
# $3 - 编译源代码路径（Make文件路径），默认为内核源代码根目录
# $4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
# $5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
# $6 - 指定编译目录，默认为 “$MSYSTEM_build”
core_name=$1
core=$2
core_src=${3:-"."}
core_dest=${4:-"."}
core_output=${5:-${core}_libretro.dll}
build_dir=${6:-${MSYSTEM,,}_build}

cmake_clean="cmake --build $build_dir --target clean -j"
cmake_gen="cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release $cmake_params -G Ninja -B $build_dir" # -DCMAKE_POLICY_DEFAULT_CMP0198=NEW -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake_build="cmake --build $build_dir --target ${core}_libretro --config Release -j"
if [[ $build_mt -gt 0 ]]; then cmake_build+=" $build_mt"; fi

if [[ ! -d "$cores_dir/libretro-$core/$core_src" ]]; then die "内核 \"$core_name\" 目录 \"$cores_dir/libretro-$core/$core_src\" 不存在，请先拉取内核源代码！"; fi
cd "$cores_dir/libretro-$core/$core_src" >/dev/null

if [[ -z $no_regen && -d "$build_dir" ]]; then
   message "删除内核 \"$core_name\" 编译目录 (rm -r -f \"$build_dir\")..."
   rm -r -f "$build_dir" || die "删除 \"$core_name\" 编译目录出错！"
   echo
fi
    
if [[ -z $no_clean && -f "$build_dir/build.ninja" ]]; then
    message "清理内核 \"$core_name\" ($cmake_clean)..."            
    $cmake_clean
    echo
fi

unset phase1_time
SECONDS=0
if [[ ! -f "$build_dir/build.ninja" ]]; then
    message "生成内核 \"$core_name\" 编译配置文件 ($cmake_gen)..."
    $cmake_gen || die "生成内核 \"$core_name\" 编译配置文件出错！"
    phase1_time=$SECONDS
    echo
fi

message "编译内核 \"$core_name\" ($cmake_build)..."
$cmake_build || die "编译内核 \"$core_name\" 出错！"
total_time=$SECONDS
phase2_time=$total_time
echo

cd "$cores_dir/libretro-$core/$core_src"
strip -s "$core_dest/$core_output" || die "裁剪内核 \"$core_name\" dll文件出错！"
cp -v "$core_dest/$core_output" "$dists_dir/$core_output" || die "拷贝内核 \"$core_name\" dll文件到分发目录出错！"
echo

if [[ -v phase1_time ]]; then
    phase2_time=$((total_time - phase1_time))
    echo "生成内核 \"$core_name\" 编译配置文件用时：$((phase1_time / 60))分$((phase1_time % 60))秒"
fi
echo "编译内核 \"$core_name\" 用时：$((phase2_time / 60))分$((phase2_time % 60))秒"
echo "编译内核 \"$core_name\" 总用时：$((total_time / 60))分$((total_time % 60))秒"
echo 

message "编译内核 \"$core_name\" 完成。"
echo
exit 0

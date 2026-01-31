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
# $6 - 指定编译目录，默认为Build
core_name=$1
core=$2
core_src=${3:-"."}
core_dest=${4:-"."}
core_output=${5:-$core"_libretro.dll"}
build_dir=${6:-"Build"}

cd "$cores_dir/libretro-$core/$core_src"

if [[ ! -v $no_clean && -d "$build_dir" ]]; then
    #message "清理 \"$core_name\" (cmake --build $build_dir --target clean -j`nproc`)..."            
    #cmake --build $build_dir --target clean -j`nproc`
    message "清理 \"$core_name\"，删除编译目录 (rm -r -f $build_dir)..."
    rm -r -f "$build_dir" || die "清理 \"$core_name\" 出错！"
fi

# -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_POLICY_DEFAULT_CMP0198=NEW
message "生成编译配置文件 (cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -B $build_dir $cmake_params)..."
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -B $build_dir $cmake_params || die "生成编译配置文件出错！"
echo

message "编译 \"$core_name\" (cmake --build $build_dir --target $core"_libretro" --config Release -j`nproc`)..."
cmake --build $build_dir --target $core"_libretro" --config Release -j`nproc` || die "编译 \"$core_name\" 出错！"
echo
        
strip -s "$core_dest/$core_output" || die "strip 出错！"
cp -v "$core_dest/$core_output" "$dists_dir/" || die "拷贝内核到分发目录出错！"
echo

message "\"$core_name\" 编译内核 \"$core_name\" 完成。"
echo
exit 0

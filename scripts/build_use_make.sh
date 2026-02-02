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

c_disabled_warnings="-Wno-misleading-indentation -Wno-multichar -Wno-attributes"
cxx_disabled_warnings="-Wno-misleading-indentation -Wno-template-id-cdtor -Wno-class-memaccess -Wno-narrowing -Wno-cast-user-defined"
cpp_disabled_warnings="-Wno-undef -Wno-misleading-indentation"

# 使用make编译通用方法，参数说明：
# $1 - 内核显示名称
# $2 - 内核名称
# $3 - 编译源代码路径（Make文件路径），默认为内核源代码根目录
# $4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
# $5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
core_name=$1
core=$2
core_src=${3:-"."}
core_dest=${4:-"."}
core_output=${5:-$core"_libretro.dll"}

cd "$cores_dir/libretro-$core/$core_src" >/dev/null || die "进入内核 \"$core_name\" 源代码目录失败！"
    
make_file="Makefile"
if [ -f "Makefile.libretro" ]; then
    make_file="Makefile.libretro"
elif [ -f "GNUmakefile" ]; then
    make_file="GNUmakefile"
fi
    
if [ -z "$CXXFLAGS" ]; then CXXFLAGS="$cxx_disable_warnings"; else CXXFLAGS+=" $cxx_disable_warnings"; fi
if [ -z "$CFLAGS" ]; then CFLAGS="$c_disabled_warnings"; else CFLAGS+=" $c_disabled_warnings"; fi
if [ -z "$CPPFLAGS" ]; then CPPFLAGS="$cpp_disabled_warnings"; else CPPFLAGS+=" $cpp_disabled_warnings"; fi
export CFLAGS
export CXXFLAGS
export CPPFLAGS

make_clean="make -f $make_file -j`nproc` $make_params clean"
make_build="make -f $make_file -j`nproc` $make_params"

if [[ ! -v no_clean ]]; then
    message "清理内核 \"$core_name\" ($make_clean)..."
    $make_clean
    echo
fi

if [[ ! -v no_ccache ]]; then
    message "编译内核 \"$core_name\" (ccache $make_build)..."
    ccache $make_build || die "编译 \"$core_name\" 出错！"
else
    message "编译内核 \"$core_name\" ($make_build)..."
    $make_build || die "编译 \"$core_name\" 出错！"
fi
echo

cd "$cores_dir/libretro-$core/$core_src"
strip -s "$core_dest/$core_output" || die "裁剪内核 \"$core_name\" dll文件出错！"
cp -v "$core_dest/$core_output" "$dists_dir/" || die "拷贝内核 \"$core_name\" dll文件到分发目录出错！"
echo

message "编译内核 \"$core_name\" 完成。"
echo
exit 0

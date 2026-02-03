#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

dist_core() {
    if [[ "$1" =~ .*_libretro\.dll$ ]]; then 
        core_file=$1
    else
        core_file=$1_libretro.dll
    fi
    if [[ ! -f "$cores_dists_dir/$core_file" ]]; then error_message "内核文件 \"$core_file\" 不存在！"; return 1; fi
    
    message "拷贝内核 \"$core_file\"..."
    cp -v "$cores_dists_dir/$core_file" "$ra_cores_dists_dir/"
    
    pushd . >/dev/null
    cd "$ra_dists_dir"
    message "拷贝内核 \"$1\" 依赖的运行库..."
    for i in $(seq 3); do for dll in $(ntldd -R cores/$core_file | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$dll" . ; done; done
    popd >/dev/null
    message "完成"
    echo
}

if [ $# -lt 1 ]; then die "需要指定内核！all - 指定全部可用内核。"; fi

cd "$(dirname "$0")"
cd ..
cores_dists_dir="$PWD/cores/dists"
ra_dists_dir="$PWD/retroarch_dist"
ra_cores_dists_dir="$PWD/retroarch_dist/cores"
if [ ! -d "$cores_dists_dir" ]; then die "内核输出目录不存在！请先编译内核。"; fi
if [ ! -d "$ra_cores_dists_dir" ]; then mkdir -p "$ra_cores_dists_dir" >dev/nul; fi
cd "$cores_dists_dir"

if [[ ${1,,} = "all" ]]; then
    for file in *.dll; do dist_core "$file" || die "分发内核 \"$file\" 出错！"; done
else
    while [ $# -gt 0 ]; do 
       dist_core "$1" || die "分发内核 \"$1\" 出错！"
       shift
   done
fi

message "全部完成"
exit 0
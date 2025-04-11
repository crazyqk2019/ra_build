#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_RED="echo -en \\E[1;31m"
SETCOLOR_NORMAL="echo -en \\E[0m"

cd "$(dirname "$0")" >/dev/null

die()
{
    if [ $# -gt 0 ]; then
        $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
        echo
    fi
    exit 1
}

message()
{
   $SETCOLOR_GREEN && echo "$@" && $SETCOLOR_NORMAL
}

error_message()
{
   $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
}

if [ $# -lt 1 ]; then die "需要指定内核文件！all - 指定全部可用内核。"; fi

cd ..
if [ ! -d cores/dists ]; then die "内核输出目录不存在！请先编译内核。"; fi
if [ ! -d retroarch_dist/cores ]; then mkdir -p retroarch_dist/cores >dev/nul; fi
cores_dir="$PWD/cores/dists"
ra_dists_dir="$PWD/retroarch_dist"
ra_cores_dists_dir="$PWD/retroarch_dist/cores"
cd cores/dists

dist_core() {
    if [ ! -f "$cores_dir/$1" ]; then die "内核文件 \"$1\" 不存在！"; fi
    message "拷贝 \"$1\"..."
    cp -v "$cores_dir/$1" "$ra_cores_dists_dir/"
    cd "$ra_dists_dir"
    message "拷贝 \"$1\" 依赖的运行库..."
    for i in $(seq 3); do for dll in $(ntldd -R cores/$1 | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$dll" . ; done; done
    message "完成"
    echo
}

if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "all" ]; then
    for file in *.dll; do dist_core "$file"; done
else
    while [ $# -gt 0 ]; do 
       pushd . >/dev/null
       dist_core $1
       popd >/dev/null
       shift
   done
fi

message "全部完成"
exit 0
#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

copy_runtime_deps() {
    local copy_error=$1
    shift

    local dll
    local i
    for ((i = 0; i < 3; i++)); do
        while IFS= read -r dll; do
            cp -v -- "$dll" . || die "$copy_error"
        done < <(
            ntldd -R "$@" |
                grep -i 'msys64' |
                sed -nE 's/^[^>]*>[[:space:]]*(.*)[[:space:]]+\(0x[[:xdigit:]]+\)[[:space:]]*$/\1/p'
        )
    done
}

dist_core() {
    if [[ "$1" =~ .*_libretro\.dll$ ]]; then
        core_file=$1
    else
        core_file=$1_libretro.dll
    fi
    if [[ ! -f "$cores_dists_dir/$core_file" ]]; then error_message "内核文件 \"$core_file\" 不存在！"; return 1; fi
    
    message "拷贝内核 \"$core_file\"..."
    cp -v "$cores_dists_dir/$core_file" "$ra_cores_dists_dir/" || die "拷贝内核失败：$cores_dists_dir/$core_file"

    pushd . >/dev/null
    cd "$ra_dists_dir" || die "变更目录失败！"
    message "拷贝内核 \"$1\" 依赖的运行库..."
    # shellcheck disable=SC2034
    #for i in $(seq 3); do for dll in $(ntldd -R "cores/$core_file" | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do
    #    cp -v "$dll" . || die "拷贝依赖库失败！"
    #done; done
    copy_runtime_deps "拷贝依赖库失败！" "cores/$core_file"
    popd >/dev/null || die "变更目录失败！"
    message "完成"
    echo
}

if [ $# -lt 1 ]; then die "需要指定内核！all - 指定全部可用内核。"; fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "${SCRIPT_DIR}" || die "变更目录失败！"
cd ..
cores_dists_dir="$PWD/cores/dists"
ra_dists_dir="$PWD/retroarch_dist"
ra_cores_dists_dir="$PWD/retroarch_dist/cores"
if [ ! -d "$cores_dists_dir" ]; then die "内核输出目录不存在！请先编译内核。"; fi
if [ ! -d "$ra_cores_dists_dir" ]; then
    mkdir -p "$ra_cores_dists_dir" >/dev/null || die "创建内核分发目录失败！"
fi
cd "$cores_dists_dir" || die "变更目录失败！"

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
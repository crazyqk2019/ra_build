#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }


pushd "$(dirname "$0")" >/dev/null || die "变更目录失败！"

if [[ -d ../retroarch ]]; then die "目标目录已存在！"; fi

message "克隆 RetroArch ……"
if ! git clone --recursive https://github.com/crazyqk2019/RetroArch ../retroarch; then
    error_message "克隆出错！"
    if [[ -d ../retroarch ]]; then
        rm -r -f ../retroarch || error_message "删除未完成目录../retroarch失败！"
    fi
    die
fi
message "完成。"
echo

cd ../retroarch || die "变更目录失败！"

message "添加上游仓库……"
git remote add upstream https://github.com/libretro/RetroArch || die "添加上游仓库出错！"
message "完成。"
echo

message "克隆 RetroArch 完成。"

popd >/dev/null || die "变更目录失败！"

exit 0



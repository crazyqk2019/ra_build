#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_RED="echo -en \\E[1;31m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"
die()
{
    if [ $# -gt 0 ]; then
        $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
    fi
    exit 1
}

error_message()
{
    $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
}

message()
{
   $SETCOLOR_GREEN && echo "$@" && $SETCOLOR_NORMAL
}

pushd $(dirname "$0") >/dev/null

message "克隆原版 RetroArch ……"
git clone --recursive https://github.com/libretro/RetroArch ../retroarch_orig || die "克隆出错！"
message "完成。"
echo

# $SETCOLOR_GREEN && echo "Fetching submodules..." && $SETCOLOR_NORMAL
# pushd ../retroarch_orig >/dev/null
# ./fetch-submodules.sh

message "克隆原版 RetroArch 完成。"

popd >/dev/null

exit 0

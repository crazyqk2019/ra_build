#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

if [ $# -lt 1 ]; then die "需要指定RA目录，例如 ../retroarch"; fi
if [ ! -d "$1" ]; then die "目录不存在！"; fi

pushd $(dirname "$0") >/dev/null
cd "$1" >/dev/null || exit $?

message "配置 RetroArch 编译……"
./configure || die "配置出错！"
message "配置完成。"
echo

message "执行清理……"
make clean
message "清理完成。"
echo

message "编译 RetroArch……"
make -j`nproc` || message "编译出错！"
strip -s retroarch.exe
echo

message "编译完成。"
exit 0
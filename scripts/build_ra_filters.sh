#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

if [ $# -lt 1 ]; then die "需要指定RA目录，例如 ../retroarch"; fi
if [ ! -d "$1" ]; then die "目录不存在！"; fi

pushd $(dirname "$0") >/dev/null
cd "$1" >/dev/null || exit $?

message "编译视频滤镜……"
pushd gfx/video_filters >/dev/null || exit $?
make clean && make -j || die "编译视频滤镜出错！"
popd >/dev/null
message "编译视频滤镜完成。"
echo

message "编译音频滤镜……"
pushd libretro-common/audio/dsp_filters >/dev/null
make clean && make -j || die "编译音频滤镜出错！"
popd >/dev/null
message "编译音频滤镜完成。"
echo

message "全部编译完成。"
exit 0

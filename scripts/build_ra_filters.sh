#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

$SETCOLOR_GREEN && echo "Build video filters..." && $SETCOLOR_NORMAL
pushd gfx/video_filters >/dev/null
make clean
make -j
popd >/dev/null

$SETCOLOR_GREEN && echo "Building audio filters(DSPs)..." && $SETCOLOR_NORMAL
pushd libretro-common/audio/dsp_filters >/dev/null
make clean
make -j
popd >/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



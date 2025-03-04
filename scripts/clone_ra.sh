#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd $(dirname "$0") >/dev/null

$SETCOLOR_GREEN && echo "Cloning RetroArch..." && $SETCOLOR_NORMAL
git clone https://github.com/crazyqk2019/RetroArch ../retroarch

cd ../retroarch

$SETCOLOR_GREEN && echo "Adding upstream repository..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/RetroArch

popd >/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL

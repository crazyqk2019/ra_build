#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd $(dirname "$0") >/dev/null

$SETCOLOR_GREEN && echo "Cloning RetroArch..." && $SETCOLOR_NORMAL
git clone https://github.com/libretro/RetroArch ../retroarch_orig

# $SETCOLOR_GREEN && echo "Fetching submodules..." && $SETCOLOR_NORMAL
# pushd ../retroarch_orig >/dev/null
# ./fetch-submodules.sh

popd >/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL

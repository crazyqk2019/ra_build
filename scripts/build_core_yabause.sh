#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-yabause
cd yabause/src/libretro

$SETCOLOR_GREEN && echo "Cleaning yabause..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building yabause..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null

strip -s yabause_libretro.dll
cp yabause_libretro.dll ../../../../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning yabause..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


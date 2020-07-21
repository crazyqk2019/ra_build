#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-nestopia
cd libretro
$SETCOLOR_GREEN && echo "Cleaning nestopia..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building nestopia..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null

strip -s nestopia_libretro.dll
cp nestopia_libretro.dll ../../../retroarch_dist/cores/
cd ../../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


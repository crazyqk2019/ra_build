#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-mupen64plus_next
$SETCOLOR_GREEN && echo "Cleaning mupen64plus_next..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mupen64plus_next..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null

strip -s mupen64plus_next_libretro.dll
cp mupen64plus_next_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


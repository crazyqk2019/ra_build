#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-mednafen_psx_hw
$SETCOLOR_GREEN && echo "Cleaning mednafen_psx_hw..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mednafen_psx_hw..." && $SETCOLOR_NORMAL
make HAVE_HW=1 -j`nproc` &>/dev/null
strip -s mednafen_psx_hw_libretro.dll
cp mednafen_psx_hw_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-mednafen_saturn
$SETCOLOR_GREEN && echo "Cleaning mednafen_saturn..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mednafen_saturn..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null

strip -s mednafen_saturn_libretro.dll
cp mednafen_saturn_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


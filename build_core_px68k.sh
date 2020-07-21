#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-px68k
$SETCOLOR_GREEN && echo "Cleaning px68k..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

$SETCOLOR_GREEN && echo "Building px68k..." && $SETCOLOR_NORMAL
make -f Makefile.libretro -j`nproc` &>/dev/null

strip -s px68k_libretro.dll
cp px68k_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


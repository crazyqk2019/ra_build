#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-mame2015
$SETCOLOR_GREEN && echo "Cleaning mame2015..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mame2015..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null

strip -s mame2015_libretro.dll
cp mame2015_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


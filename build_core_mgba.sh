#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-mgba
$SETCOLOR_GREEN && echo "Cleaning mgba..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mgba..." && $SETCOLOR_NORMAL
make -f Makefile.libretro -j`nproc` &>/dev/null

strip -s mgba_libretro.dll
cp mgba_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


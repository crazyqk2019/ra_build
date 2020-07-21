#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-fceumm
$SETCOLOR_GREEN && echo "Cleaning fceumm..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

$SETCOLOR_GREEN && echo "Building fceumm..." && $SETCOLOR_NORMAL
make -f Makefile.libretro -j`nproc` &>/dev/null

strip -s fceumm_libretro.dll
cp fceumm_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


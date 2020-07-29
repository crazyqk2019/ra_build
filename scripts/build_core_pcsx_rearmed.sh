#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-pcsx_rearmed

$SETCOLOR_GREEN && echo "Cleaning pcsx_rearmed..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

$SETCOLOR_GREEN && echo "Building pcsx_rearmed..." && $SETCOLOR_NORMAL
make -f Makefile.libretro -j`nproc` &>/dev/null

strip -s pcsx_rearmed_libretro.dll
cp pcsx_rearmed_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning pcsx_rearmed..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


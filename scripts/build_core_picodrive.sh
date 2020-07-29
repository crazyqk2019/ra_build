#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-picodrive

$SETCOLOR_GREEN && echo "Cleaning picodrive..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

$SETCOLOR_GREEN && echo "Building picodrive..." && $SETCOLOR_NORMAL
make -f Makefile.libretro -j`nproc` &>/dev/null

strip -s picodrive_libretro.dll
cp picodrive_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning picodrive..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


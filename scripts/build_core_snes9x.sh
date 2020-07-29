#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-snes9x
cd libretro

$SETCOLOR_GREEN && echo "Cleaning snes9x..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building snes9x..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null

strip -s snes9x_libretro.dll
cp snes9x_libretro.dll ../../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning snes9x..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


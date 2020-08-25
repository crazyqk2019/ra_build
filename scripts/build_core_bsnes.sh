#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-bsnes
cd bsnes

$SETCOLOR_GREEN && echo "Cleaning bsnes..." && $SETCOLOR_NORMAL
make -f GNUmakefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building bsnes..." && $SETCOLOR_NORMAL
make -f GNUmakefile target=libretro binary=library -j`nproc` &>/dev/null
strip -s out/bsnes_libretro.dll
cp out/bsnes_libretro.dll ../../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning bsnes..." && $SETCOLOR_NORMAL
make -f GNUmakefile clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-desmume
cd desmume/src/frontend/libretro

$SETCOLOR_GREEN && echo "Cleaning DeSmuME..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building DeSmuME..." && $SETCOLOR_NORMAL
make -j`nproc` &>/dev/null
strip -s desmume_libretro.dll
cp desmume_libretro.dll ../../../../../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning DeSmuME..." && $SETCOLOR_NORMAL
make clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


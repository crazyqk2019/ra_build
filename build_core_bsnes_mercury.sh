#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-bsnes_mercury
$SETCOLOR_GREEN && echo "Cleaning bsnes_mercury..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building bsnes_mercury..." && $SETCOLOR_NORMAL
make profile=accuracy -j`nproc` &>/dev/null
strip -s ./out/bsnes_mercury_accuracy_libretro.dll
cp ./out/bsnes_mercury_accuracy_libretro.dll ../../cores_dist/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


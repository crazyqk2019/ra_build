#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores/libretro-bsnes_mercury

$SETCOLOR_GREEN && echo "Cleaning bsnes_mercury_accuracy..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building bsnes_mercury_accuracy..." && $SETCOLOR_NORMAL
make profile=accuracy -j`nproc` &>/dev/null
strip -s ./out/bsnes_mercury_accuracy_libretro.dll
cp ./out/bsnes_mercury_accuracy_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning bsnes_mercury_accuracy..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building bsnes_mercury_balanced..." && $SETCOLOR_NORMAL
make profile=accuracy -j`nproc` &>/dev/null
strip -s ./out/bsnes_mercury_accuracy_libretro.dll
cp ./out/bsnes_mercury_balanced_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning bsnes_mercury_balanced..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building bsnes_mercury_performance..." && $SETCOLOR_NORMAL
make profile=accuracy -j`nproc` &>/dev/null
strip -s ./out/bsnes_mercury_accuracy_libretro.dll
cp ./out/bsnes_mercury_performance_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning bsnes_mercury_performance..." && $SETCOLOR_NORMAL
make clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


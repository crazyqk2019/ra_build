#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../retroarch
$SETCOLOR_GREEN && echo "Configuring RetroArch..." && $SETCOLOR_NORMAL
./configure --disable-qt

$SETCOLOR_GREEN && echo "Cleaning RetroArch..." && $SETCOLOR_NORMAL
make clean

$SETCOLOR_GREEN && echo "Building RetroArch..." && $SETCOLOR_NORMAL
make -j`nproc`
strip -s retroarch.exe
cp retroarch.exe ../retroarch_dist/

$SETCOLOR_GREEN && echo "Cleaning RetroArch..." && $SETCOLOR_NORMAL
make clean

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



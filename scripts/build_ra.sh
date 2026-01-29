#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd $(dirname "$0") >/dev/null
cd ../retroarch >/dev/null || exit $?

$SETCOLOR_GREEN && echo "Configuring RetroArch..." && $SETCOLOR_NORMAL
./configure
echo

$SETCOLOR_GREEN && echo "Cleaning RetroArch..." && $SETCOLOR_NORMAL
make clean
echo

$SETCOLOR_GREEN && echo "Building RetroArch..." && $SETCOLOR_NORMAL
make -j`nproc`
strip -s retroarch.exe
echo

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-parallel_n64
$SETCOLOR_GREEN && echo "Cleaning parallel_n64..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building parallel_n64..." && $SETCOLOR_NORMAL
make HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64 -j`nproc` &>/dev/null
strip -s parallel_n64_libretro.dll
cp parallel_n64_libretro.dll ../../retroarch_dist/cores/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



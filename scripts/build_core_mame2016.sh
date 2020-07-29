#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null
cd ../cores/libretro-mame2016

$SETCOLOR_GREEN && echo "Cleaning mame2016..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mame2016..." && $SETCOLOR_NORMAL
make -f Makefile.libretro -j`nproc` &>/dev/null
strip -s mame2016_libretro.dll
cp mame2016_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning mame2016..." && $SETCOLOR_NORMAL
make -f Makefile.libretro clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


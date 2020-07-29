#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null
cd ../cores/libretro-mame2003_plus

$SETCOLOR_GREEN && echo "Cleaning mame2003_plus..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

$SETCOLOR_GREEN && echo "Building mame2003_plus..." && $SETCOLOR_NORMAL
make -f Makefile -j`nproc` &>/dev/null
strip -s mame2003_plus_libretro.dll
cp mame2003_plus_libretro.dll ../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning mame2003_plus..." && $SETCOLOR_NORMAL
make -f Makefile clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


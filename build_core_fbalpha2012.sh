#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

cd cores/libretro-fbalpha2012
$SETCOLOR_GREEN && echo "Cleaning fbalpha2012..." && $SETCOLOR_NORMAL
./compile_libretro.sh clean &>/dev/null

$SETCOLOR_GREEN && echo "Building fbalpha2012..." && $SETCOLOR_NORMAL
./compile_libretro.sh make &>/dev/null
strip -s ./svn-current/trunk/fbalpha2012_libretro.dll
cp ./svn-current/trunk/fbalpha2012_libretro.dll ../../cores_dist/
cd ../..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL


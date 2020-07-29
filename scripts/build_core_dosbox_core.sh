#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null
cd ../cores/libretro-dosbox_core
cd libretro

$SETCOLOR_GREEN && echo "Cleaning dosbox_core..." && $SETCOLOR_NORMAL
make clean &>/dev/null

$SETCOLOR_GREEN && echo "Building dosbox_core..." && $SETCOLOR_NORMAL
make BUNDLED_AUDIO_CODECS=0 BUNDLED_LIBSNDFILE=0 WITH_DYNAREC=x86_64 -j`nproc` &>/dev/null
strip -s dosbox_core_libretro.dll
cp dosbox_core_libretro.dll ../../../retroarch_dist/cores/
cd ../../../retroarch_dist/cores/
../../scripts/dist_core.sh dosbox_core_libretro.dll

cd ../../cores/libretro-dosbox_core/libretro
$SETCOLOR_GREEN && echo "Cleaning dosbox_core..." && $SETCOLOR_NORMAL
make clean &>/dev/null

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



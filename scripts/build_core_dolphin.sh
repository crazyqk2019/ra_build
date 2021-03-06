#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

VCVARS64_BAT=`../tools/vswhere.exe -latest -property installationPath`\\VC\\Auxiliary\\Build\\vcvars64.bat

cd ../cores/libretro-dolphin

$SETCOLOR_GREEN && echo "Cleaning dolphin..." && $SETCOLOR_NORMAL
rm -r -f build

$SETCOLOR_GREEN && echo "Building dolphin..." && $SETCOLOR_NORMAL
mkdir build
cd build
../../../scripts/vc_build_dolphin.bat "$VCVARS64_BAT" &>/dev/null
cp Binaries/Release/dolphin_libretro.dll ../../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning dolphin..." && $SETCOLOR_NORMAL
cd ..
rm -r -f build

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



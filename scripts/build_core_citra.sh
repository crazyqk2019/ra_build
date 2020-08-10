#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

VCVARS64_BAT=`../tools/vswhere.exe -latest -property installationPath`\\VC\\Auxiliary\\Build\\vcvars64.bat

cd ../cores/libretro-citra

$SETCOLOR_GREEN && echo "Cleaning Citra..." && $SETCOLOR_NORMAL
rm -r -f build

mkdir build
cd build

# MinGW-w64 Build with MSYS2
#$SETCOLOR_GREEN && echo "Building Citra using MSYS2..." && $SETCOLOR_NORMAL
#cmake -G "MSYS Makefiles" -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCMAKE_BUILD_TYPE="Release" .. &>/dev/null
#cd src/citra_libretro
#make -j`nproc` &>/dev/null
#cd ../..
#strip -s ./bin/citra_libretro.dll
#cp ./bin/citra_libretro.dll ../../../retroarch_dist/cores/

# MSVC Build for Windows
$SETCOLOR_GREEN && echo "Building Citra using MSVC2019..." && $SETCOLOR_NORMAL
../../../scripts/vc_build_citra.bat "$VCVARS64_BAT" &>/dev/null
cp ./bin/Release/citra_libretro.dll ../../../retroarch_dist/cores/

$SETCOLOR_GREEN && echo "Cleaning Citra..." && $SETCOLOR_NORMAL
cd ..
rm -r -f build

popd &>/dev/null

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL



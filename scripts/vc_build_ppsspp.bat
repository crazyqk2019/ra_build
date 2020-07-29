@echo off
call %1
cmake -G "Visual Studio 16 2019" -DLIBRETRO=ON -DCMAKE_CXX_FLAGS_RELEASE="/MT /UTF-8" ..
cd libretro
msbuild ppsspp_libretro.vcxproj -p:Platform=x64;Configuration=Release
cd ..

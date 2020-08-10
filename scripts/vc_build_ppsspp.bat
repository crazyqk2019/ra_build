@echo off
cmake -G "Visual Studio 16 2019" -DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/MT /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MT /utf-8" ..
cd libretro
msbuild ppsspp_libretro.vcxproj -p:Platform=x64;Configuration=Release
cd ..

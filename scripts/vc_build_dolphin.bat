@echo off
call %1
cmake -G "Visual Studio 16 2019" -DLIBRETRO=ON -DCMAKE_CXX_FLAGS_RELEASE="/MT /utf-8 /D_SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING" ..
cd Source\Core\DolphinLibretro
msbuild dolphin_libretro.vcxproj -p:Platform=x64;Configuration=Release
cd ..\..\..

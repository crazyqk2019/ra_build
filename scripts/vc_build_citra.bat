@echo off
call %1
cmake -G "Visual Studio 16 2019" -DENABLE_LIBRETRO=ON -DENABLE_QT=OFF -DENABLE_SDL2=OFF -DENABLE_WEB_SERVICE=OFF ..
cd src\citra_libretro
msbuild citra_libretro.vcxproj -p:Platform=x64;Configuration=Release
cd ..\..

#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

$SETCOLOR_GREEN && echo "Clearing dist directory ..." && $SETCOLOR_NORMAL
rm -r ../retroarch_dist
mkdir ../retroarch_dist

$SETCOLOR_GREEN && echo "Copying main exe and default config file..." && $SETCOLOR_NORMAL
cp -v ./retroarch.exe ../retroarch_dist
cp -v ./retroarch.cfg ../retroarch_dist/retroarch.default.cfg

$SETCOLOR_GREEN && echo "Copying dependent runtimes..." && $SETCOLOR_NORMAL
pushd ../retroarch_dist >/dev/null
for bin in $(ntldd -R retroarch.exe | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$bin" . ; done;
windeployqt6 retroarch.exe
for bin in $(ntldd -R imageformats/*dll | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$bin" . ; done;
popd >/dev/null

$SETCOLOR_GREEN && echo "Copying video filters..." && $SETCOLOR_NORMAL
mkdir -p ../retroarch_dist/filters/video
cp -v -t ../retroarch_dist/filters/video gfx/video_filters/*.dll gfx/video_filters/*.filt

$SETCOLOR_GREEN && echo "Copying audio filters..." && $SETCOLOR_NORMAL
mkdir -p ../retroarch_dist/filters/audio
cp -v -t ../retroarch_dist/filters/audio libretro-common/audio/dsp_filters/*.dll libretro-common/audio/dsp_filters/*.dsp

pushd ../retroarch_dist >/dev/null

$SETCOLOR_GREEN && echo "Downloading assets..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/assets.zip
7z x assets.zip -oassets
rm assets.zip

$SETCOLOR_GREEN && echo "Downloading game controller configs..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/autoconfig.zip
7z x autoconfig.zip -oautoconfig
rm autoconfig.zip

$SETCOLOR_GREEN && echo "Downloading cheating codes..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/cheats.zip
7z x cheats.zip -ocheats
rm cheats.zip

$SETCOLOR_GREEN && echo "Downloading databases..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/database-rdb.zip
7z x database-rdb.zip -odatabase/rdb
rm database-rdb.zip

$SETCOLOR_GREEN && echo "Downloading database cursor samples..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/database-cursors.zip
7z x database-cursors.zip -odatabase/cursors
rm database-cursors.zip

$SETCOLOR_GREEN && echo "Downloading core infos..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/info.zip
7z x info.zip -oinfo
rm info.zip

$SETCOLOR_GREEN && echo "Downloading overlays..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/overlays.zip
7z x overlays.zip -ooverlays
rm overlays.zip

$SETCOLOR_GREEN && echo "Downloading shaders..." && $SETCOLOR_NORMAL
wget https://buildbot.libretro.com/assets/frontend/shaders_cg.zip
7z x shaders_cg.zip -oshaders/shaders_cg
rm shaders_cg.zip

wget https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip
7z x shaders_glsl.zip -oshaders/shaders_glsl
rm shaders_glsl.zip

wget https://buildbot.libretro.com/assets/frontend/shaders_slang.zip
7z x shaders_slang.zip -oshaders/shaders_slang
rm shaders_slang.zip

popd >/dev/null


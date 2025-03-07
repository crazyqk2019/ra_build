#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_RED="echo -en \\E[1;31m"
SETCOLOR_NORMAL="echo -en \\E[0m"

die()
{
    if [ $# -gt 0 ]; then
        $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
    fi
    exit 1
}

message()
{
   echo ""
   $SETCOLOR_GREEN && echo "================================" && $SETCOLOR_NORMAL
   $SETCOLOR_GREEN && echo "$@" && $SETCOLOR_NORMAL
   $SETCOLOR_GREEN && echo "================================" && $SETCOLOR_NORMAL
   echo ""
}

message "Clearing dist directory ..."
rm -r ../retroarch_dist
mkdir ../retroarch_dist
echo

message "Copying main exe and default config file..."
cp -v ./retroarch.exe ../retroarch_dist
cp -v ./retroarch.cfg ../retroarch_dist/retroarch.default.cfg
echo

message "Copying dependent runtimes..."
pushd ../retroarch_dist >/dev/null
for bin in $(ntldd -R retroarch.exe | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$bin" . ; done;
windeployqt6 retroarch.exe
for bin in $(ntldd -R imageformats/*dll | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$bin" . ; done;
popd >/dev/null
echo

message "Copying video filters..."
mkdir -p ../retroarch_dist/filters/video
cp -v -t ../retroarch_dist/filters/video gfx/video_filters/*.dll gfx/video_filters/*.filt
echo

message "Copying audio filters..."
mkdir -p ../retroarch_dist/filters/audio
cp -v -t ../retroarch_dist/filters/audio libretro-common/audio/dsp_filters/*.dll libretro-common/audio/dsp_filters/*.dsp
echo

pushd ../retroarch_dist >/dev/null

message "Downloading assets..."
wget https://buildbot.libretro.com/assets/frontend/assets.zip
7z x assets.zip -oassets
rm assets.zip
echo

message "Downloading game controller configs..."
wget https://buildbot.libretro.com/assets/frontend/autoconfig.zip
7z x autoconfig.zip -oautoconfig
rm autoconfig.zip
echo

message "Downloading cheating codes..."
wget https://buildbot.libretro.com/assets/frontend/cheats.zip
7z x cheats.zip -ocheats
rm cheats.zip
echo

message "Downloading databases..."
wget https://buildbot.libretro.com/assets/frontend/database-rdb.zip
7z x database-rdb.zip -odatabase/rdb
rm database-rdb.zip
echo

message "Downloading database cursor samples..."
wget https://buildbot.libretro.com/assets/frontend/database-cursors.zip
7z x database-cursors.zip -odatabase/cursors
rm database-cursors.zip
echo

message "Downloading core infos..."
wget https://buildbot.libretro.com/assets/frontend/info.zip
7z x info.zip -oinfo
rm info.zip
echo

message "Downloading overlays..."
wget https://buildbot.libretro.com/assets/frontend/overlays.zip
7z x overlays.zip -ooverlays
rm overlays.zip
echo

message "Downloading shaders..."
wget https://buildbot.libretro.com/assets/frontend/shaders_cg.zip
7z x shaders_cg.zip -oshaders/shaders_cg
rm shaders_cg.zip
echo

wget https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip
7z x shaders_glsl.zip -oshaders/shaders_glsl
rm shaders_glsl.zip
echo

wget https://buildbot.libretro.com/assets/frontend/shaders_slang.zip
7z x shaders_slang.zip -oshaders/shaders_slang
rm shaders_slang.zip
echo

popd >/dev/null


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
   $SETCOLOR_GREEN && echo "$@" && $SETCOLOR_NORMAL
}

message "清理分发目录..."
rm -r ../retroarch_dist
mkdir ../retroarch_dist
message "完成"
echo

message "拷贝RA主执行文件和缺省配置文件..."
cp -v ./retroarch.exe ../retroarch_dist
cp -v ./retroarch.cfg ../retroarch_dist/retroarch.default.cfg
message "完成"
echo

message "拷贝依赖的运行库..."
pushd ../retroarch_dist >/dev/null
for i in $(seq 3); do for dll in $(ntldd -R retroarch.exe | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$dll" . ; done; done
windeployqt6 retroarch.exe
for i in $(seq 3); do for dll in $(ntldd -R imageformats/*dll | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$dll" . ; done; done
popd >/dev/null
message "完成"
echo

message "Copying video filters..."
mkdir -p ../retroarch_dist/filters/video
cp -v -t ../retroarch_dist/filters/video gfx/video_filters/*.dll gfx/video_filters/*.filt
message "完成"
echo

message "Copying audio filters..."
mkdir -p ../retroarch_dist/filters/audio
cp -v -t ../retroarch_dist/filters/audio libretro-common/audio/dsp_filters/*.dll libretro-common/audio/dsp_filters/*.dsp
message "完成"
echo

pushd ../retroarch_dist >/dev/null

message "下载资源文件..."
wget https://buildbot.libretro.com/assets/frontend/assets.zip || die
7z x assets.zip -oassets || die
rm assets.zip
message "完成"
echo

message "下载手柄摇杆配置文件..."
wget https://buildbot.libretro.com/assets/frontend/autoconfig.zip || die
7z x autoconfig.zip -oautoconfig || die
rm autoconfig.zip
message "完成"
echo

message "下载金手指文件..."
wget https://buildbot.libretro.com/assets/frontend/cheats.zip || die
7z x cheats.zip -ocheats || die
rm cheats.zip
message "完成"
echo

message "下载数据库文件..."
wget https://buildbot.libretro.com/assets/frontend/database-rdb.zip || die
7z x database-rdb.zip -odatabase/rdb || die
rm database-rdb.zip
message "完成"
echo

message "下载数据库自定义查询示例文件..."
wget https://buildbot.libretro.com/assets/frontend/database-cursors.zip || die
7z x database-cursors.zip -odatabase/cursors || die
rm database-cursors.zip
message "完成"
echo

message "下载模拟器内核信息文件..."
wget https://buildbot.libretro.com/assets/frontend/info.zip || die
7z x info.zip -oinfo || die
rm info.zip
message "完成"
echo

message "下载遮罩文件..."
wget https://buildbot.libretro.com/assets/frontend/overlays.zip || die
7z x overlays.zip -ooverlays || die
rm overlays.zip
message "完成"
echo

message "下载cg渲染器文件..."
wget https://buildbot.libretro.com/assets/frontend/shaders_cg.zip || die
7z x shaders_cg.zip -oshaders/shaders_cg || die
rm shaders_cg.zip
message "完成"
echo

message "下载glsl渲染器文件..."
wget https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip || die
7z x shaders_glsl.zip -oshaders/shaders_glsl || die
rm shaders_glsl.zip
message "完成"
echo

message "下载slang渲染器文件..."
wget https://buildbot.libretro.com/assets/frontend/shaders_slang.zip || die
7z x shaders_slang.zip -oshaders/shaders_slang || die
rm shaders_slang.zip
message "完成"
echo

popd >/dev/null

message "全部完成"


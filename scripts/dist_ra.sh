#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

if [ $# -lt 1 ]; then die "需要指定RA目录，例如 ../retroarch"; fi
if [ ! -d "$1" ]; then die "目录不存在！"; fi

cd "$1" >/dev/null || exit $?

message "清理 RA 分发目录..."
rm -r -f ../retroarch_dist
mkdir ../retroarch_dist
message "完成"
echo

message "拷贝 RA 主执行文件和缺省配置文件..."
cp -v ./retroarch.exe ../retroarch_dist/
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

message "拷贝视频滤镜……"
mkdir -p ../retroarch_dist/filters/video
cp -v -t ../retroarch_dist/filters/video gfx/video_filters/*.dll gfx/video_filters/*.filt
message "完成"
echo

message "拷贝音频滤镜……"
mkdir -p ../retroarch_dist/filters/audio
cp -v -t ../retroarch_dist/filters/audio libretro-common/audio/dsp_filters/*.dll libretro-common/audio/dsp_filters/*.dsp
message "完成"
echo

pushd ../retroarch_dist >/dev/null
message "下载资源文件..."
wget https://buildbot.libretro.com/assets/frontend/assets.zip || die "下载资源文件出错！"
7z x assets.zip -oassets || die "解压资源文件出错！"
rm assets.zip
message "完成"
echo

message "下载手柄摇杆配置文件..."
wget https://buildbot.libretro.com/assets/frontend/autoconfig.zip || die "下载手柄摇杆配置文件出错！"
7z x autoconfig.zip -oautoconfig || die "解压手柄摇杆配置文件出错！"
rm autoconfig.zip
message "完成"
echo

message "下载金手指文件..."
wget https://buildbot.libretro.com/assets/frontend/cheats.zip || die "下载金手指文件出错！"
7z x cheats.zip -ocheats || die "解压金手指文件出错！"
rm cheats.zip
message "完成"
echo

message "下载数据库文件..."
wget https://buildbot.libretro.com/assets/frontend/database-rdb.zip || die "下载金手指文件出错！"
7z x database-rdb.zip -odatabase/rdb || die "解压数据库文件出错！"
rm database-rdb.zip
message "完成"
echo

message "下载数据库自定义查询示例文件..."
wget https://buildbot.libretro.com/assets/frontend/database-cursors.zip || die "下载数据库自定义查询示例文件出错！"
7z x database-cursors.zip -odatabase/cursors || die "解压数据库自定义查询示例文件出错！"
rm database-cursors.zip
message "完成"
echo

message "下载模拟器内核信息文件..."
wget https://buildbot.libretro.com/assets/frontend/info.zip || die "下载模拟器内核信息文件出错！"
7z x info.zip -oinfo || die "解压模拟器内核信息文件出错！"
rm info.zip
message "完成"
echo

message "下载遮罩文件..."
wget https://buildbot.libretro.com/assets/frontend/overlays.zip || die "下载遮罩文件出错！"
7z x overlays.zip -ooverlays || die "解压遮罩文件出错！"
rm overlays.zip
message "完成"
echo

message "下载cg渲染器文件..."
wget https://buildbot.libretro.com/assets/frontend/shaders_cg.zip || die "下载cg渲染器文件出错！"
7z x shaders_cg.zip -oshaders/shaders_cg || die "解压cg渲染器文件出错！"
rm shaders_cg.zip
message "完成"
echo

message "下载glsl渲染器文件..."
wget https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip || die "下载glsl渲染器文件出错！"
7z x shaders_glsl.zip -oshaders/shaders_glsl || die "解压glsl渲染器文件出错！"
rm shaders_glsl.zip
message "完成"
echo

message "下载slang渲染器文件..."
wget https://buildbot.libretro.com/assets/frontend/shaders_slang.zip || die "下载slang渲染器文件出错！"
7z x shaders_slang.zip -oshaders/shaders_slang || die "解压slang渲染器文件出错！"
rm shaders_slang.zip
message "完成"
echo
popd >/dev/null

message "全部完成"
exit 0


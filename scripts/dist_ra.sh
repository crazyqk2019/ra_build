#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
if [ $# -lt 1 ]; then die "需要指定RA目录，例如 ../retroarch"; fi
if ! ra_dir=$(realpath -e -- "$1"); then
    die "路径不存在或无法访问：$1"
fi
ra_dist_dir=${SCRIPT_DIR}/../retroarch_dist

shopt -s nullglob
video_dlls=("${ra_dir}"/gfx/video_filters/*.dll)
video_filts=("${ra_dir}"/gfx/video_filters/*.filt)
audio_dlls=("${ra_dir}"/libretro-common/audio/dsp_filters/*.dll)
audio_dsps=("${ra_dir}"/libretro-common/audio/dsp_filters/*.dsp)

if [[ ! -f "${ra_dir}/retroarch.exe" ]]; then die "${ra_dir}/retroarch.exe不存在，请先编译RA主程序。"; fi
if [[ ! -f "${ra_dir}/retroarch.cfg" ]]; then die "${ra_dir}/retroarch.cfg不存在。"; fi
if (( ${#video_dlls[@]} == 0 )); then die "${ra_dir}/gfx/video_filters/*.dll不存在，请先编译视频滤镜。"; fi
if (( ${#audio_dlls[@]} == 0 )); then die "${ra_dir}/libretro-common/audio/dsp_filters/*.dll不存在，请先编译音频滤镜。"; fi

copy_runtime_deps() {
    local copy_error=$1
    shift

    local dll
    local i
    for ((i = 0; i < 3; i++)); do
        while IFS= read -r dll; do
            cp -v -- "$dll" . || die "$copy_error"
        done < <(
            ntldd -R "$@" |
                grep -i 'msys64' |
                sed -nE 's/^[^>]*>[[:space:]]*(.*)[[:space:]]+\(0x[[:xdigit:]]+\)[[:space:]]*$/\1/p'
        )
    done
}

message "清理 RA 分发目录..."
if [[ -d "$ra_dist_dir" ]]; then
    rm -r -f "$ra_dist_dir" || die "删除旧分发目录失败！"
fi
mkdir "$ra_dist_dir" || die "创建分发目录失败！"
message "完成"
echo

message "拷贝 RA 主执行文件和缺省配置文件..."
cp -v "${ra_dir}/retroarch.exe" "${ra_dist_dir}/retroarch.exe" || die "拷贝RA主程序失败！"
cp -v "${ra_dir}/retroarch.cfg" "${ra_dist_dir}/retroarch.default.cfg" || die "拷贝RA缺省配置文件失败！"
message "完成"
echo

message "拷贝依赖的运行库..."
pushd "${ra_dist_dir}" >/dev/null || die "变更目录失败！"
#for i in $(seq 3); do for dll in $(ntldd -R retroarch.exe | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do
#    cp -v "$dll" . || die "拷贝依赖运行库失败！"
#done; done
copy_runtime_deps "拷贝依赖运行库失败！" retroarch.exe
windeployqt6 retroarch.exe || die "拷贝Qt运行库失败！"
#for i in $(seq 3); do for dll in $(ntldd -R imageformats/*dll | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do
#    cp -v "$dll" . || die "拷贝图形插件依赖运行库失败！"
#done; done
copy_runtime_deps "拷贝Qt图形插件依赖运行库失败！" imageformats/*.dll
popd >/dev/null || die "变更目录失败！"
message "完成"
echo

message "拷贝视频滤镜……"
mkdir -p "${ra_dist_dir}/filters/video" || die "创建视频滤镜目录失败！"
cp -v -t "${ra_dist_dir}/filters/video" "${video_dlls[@]}" "${video_filts[@]}" || die "拷贝视频滤镜失败！"
message "完成"
echo

message "拷贝音频滤镜……"
mkdir -p "${ra_dist_dir}/filters/audio" || die "创建音频滤镜目录失败！"
cp -v -t "${ra_dist_dir}/filters/audio" "${audio_dlls[@]}" "${audio_dsps[@]}" || die "拷贝音频滤镜失败！"
message "完成"
echo

pushd "${ra_dist_dir}" >/dev/null || die "变更目录失败！"
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
wget https://buildbot.libretro.com/assets/frontend/database-rdb.zip || die "下载数据库文件出错！"
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
popd >/dev/null || die "变更目录失败！"

message "全部完成"
exit 0


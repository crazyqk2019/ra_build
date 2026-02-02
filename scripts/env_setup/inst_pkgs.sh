#!/bin/bash

print_usage() {
    echo "参数不正确！使用方法："
    echo "$0 <ucrt64|mingw64|clang64>"
    exit 1
}

if [ $# -ne 1 ]; then
    print_usage
fi

compiler_var_list=("mingw64" "ucrt64" "clang64")
if [[ " ${compiler_var_list[@]} " =~ " $1 " ]]; then
    compiler_var=$1
else
    print_usage
fi

if [ "$compiler_var" == "mingw64" ]; then
    compiler_var="x86_64"
elif [ "$compiler_var" == "ucrt64" ]; then
    compiler_var="ucrt-x86_64"
elif [ "$compiler_var" == "clang64" ]; then
    compiler_var="clang-x86_64"
fi

pacman -S --needed --noconfirm \
    mingw-w64-$compiler_var-7zip \
    mingw-w64-$compiler_var-libxml2 \
    mingw-w64-$compiler_var-freetype \
    mingw-w64-$compiler_var-harfbuzz \
    mingw-w64-$compiler_var-libwebp \
    mingw-w64-$compiler_var-libtiff \
    mingw-w64-$compiler_var-ffmpeg \
    mingw-w64-$compiler_var-flac \
    mingw-w64-$compiler_var-drmingw \
    mingw-w64-$compiler_var-mbedtls \
    mingw-w64-$compiler_var-glslang \
    mingw-w64-$compiler_var-spirv-tools \
    mingw-w64-$compiler_var-spirv-headers \
    mingw-w64-$compiler_var-spirv-cross \
    mingw-w64-$compiler_var-libusb \
    mingw-w64-$compiler_var-miniupnpc \
    mingw-w64-$compiler_var-SDL \
    mingw-w64-$compiler_var-SDL_image \
    mingw-w64-$compiler_var-SDL_net \
    mingw-w64-$compiler_var-SDL2 \
    mingw-w64-$compiler_var-SDL2_image \
    mingw-w64-$compiler_var-sdl3 \
    mingw-w64-$compiler_var-sdl3-image \
    mingw-w64-$compiler_var-sdl3-ttf \
    mingw-w64-$compiler_var-ninja \
    mingw-w64-$compiler_var-dlfcn \
    mingw-w64-$compiler_var-libsndfile \
    mingw-w64-$compiler_var-opusfile \
    mingw-w64-$compiler_var-fluidsynth \
    mingw-w64-$compiler_var-fmt \
    mingw-w64-$compiler_var-boost \
    mingw-w64-$compiler_var-nvidia-cg-toolkit \
    mingw-w64-$compiler_var-FAudio \
    mingw-w64-$compiler_var-directx-headers \
    mingw-w64-$compiler_var-directxtk \
    mingw-w64-$compiler_var-angleproject \
    mingw-w64-$compiler_var-qt6 \
    mingw-w64-$compiler_var-openssl \
    mingw-w64-$compiler_var-pugixml \
    mingw-w64-$compiler_var-sfml \
    mingw-w64-$compiler_var-hidapi \
    mingw-w64-$compiler_var-glew \
    mingw-w64-$compiler_var-snappy \
    mingw-w64-$compiler_var-libzip \
    mingw-w64-$compiler_var-python \
    mingw-w64-$compiler_var-python-pip \
    mingw-w64-$compiler_var-ccache \
    mingw-w64-$compiler_var-rust \
    mingw-w64-$compiler_var-glm \
    mingw-w64-$compiler_var-libutf8proc \
    mingw-w64-$compiler_var-portmidi \
    mingw-w64-$compiler_var-asio \
    mingw-w64-$compiler_var-faad2 \
    mingw-w64-$compiler_var-libmad \
    mingw-w64-$compiler_var-gtk3 \
    mingw-w64-$compiler_var-lua \
    mingw-w64-$compiler_var-mruby \
    mingw-w64-$compiler_var-squirrel
    
# 安装旧版cmake，以避免新版cmake引起的一些问题
# pacman -U https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/ucrt64/mingw-w64-$compiler_var-cmake-4.1.2-1-any.pkg.tar.zst
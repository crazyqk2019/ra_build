#!/bin/bash

print_usage() {
    echo "参数不正确！"
    echo "使用方法："
    echo "./inst_pkgs.sh <ucrt64|mingw64|clang64>"
    exit 1
}

if [ $# -ne 1 ]; then
    print_usage
fi

compiler_env_list=("mingw64" "ucrt64" "clang64")
if [[ " ${compiler_env_list[@]} " =~ " $1 " ]]; then
    compiler_env=$1
else
    print_usage
fi

echo "Installing packages for \"$compiler_env\"..."
if [ "$compiler_env" == "mingw64" ]; then
    compiler_env="x86_64"
elif [ "$compiler_env" == "ucrt64" ]; then
    compiler_env="ucrt-x86_64"
elif [ "$compiler_env" == "clang64" ]; then
    compiler_env="clang-x86_64"
fi

pacman -S --needed --noconfirm \
    wget \
    make \
    patch \
    bison \
    zip \
    mingw-w64-$compiler_env-7zip \
    mingw-w64-$compiler_env-toolchain \
    mingw-w64-$compiler_env-autotools \
    mingw-w64-$compiler_env-libc++ \
    mingw-w64-$compiler_env-cmake \
    mingw-w64-$compiler_env-ntldd \
    mingw-w64-$compiler_env-libxml2 \
    mingw-w64-$compiler_env-freetype \
    mingw-w64-$compiler_env-ffmpeg \
    mingw-w64-$compiler_env-flac \
    mingw-w64-$compiler_env-drmingw \
    mingw-w64-$compiler_env-mbedtls \
    mingw-w64-$compiler_env-glslang \
    mingw-w64-$compiler_env-spirv-tools \
    mingw-w64-$compiler_env-spirv-headers \
    mingw-w64-$compiler_env-spirv-cross \
    mingw-w64-$compiler_env-libusb \
    mingw-w64-$compiler_env-miniupnpc \
    mingw-w64-$compiler_env-SDL \
    mingw-w64-$compiler_env-SDL_image \
    mingw-w64-$compiler_env-SDL_net \
    mingw-w64-$compiler_env-SDL2 \
    mingw-w64-$compiler_env-SDL2_image \
    mingw-w64-$compiler_env-SDL3 \
    mingw-w64-$compiler_env-SDL3_image \
    mingw-w64-$compiler_env-SDL3_ttf \
    mingw-w64-$compiler_env-nasm \
    mingw-w64-$compiler_env-ninja \
    mingw-w64-$compiler_env-dlfcn \
    mingw-w64-$compiler_env-libsndfile \
    mingw-w64-$compiler_env-opusfile \
    mingw-w64-$compiler_env-fluidsynth \
    mingw-w64-$compiler_env-fmt \
    mingw-w64-$compiler_env-boost \
    mingw-w64-$compiler_env-nvidia-cg-toolkit \
    mingw-w64-$compiler_env-FAudio \
    mingw-w64-$compiler_env-directx-headers \
    mingw-w64-$compiler_env-directxtk \
    mingw-w64-$compiler_env-angleproject \
    mingw-w64-$compiler_env-qt6 \
    mingw-w64-$compiler_env-openssl \
    mingw-w64-$compiler_env-pugixml \
    mingw-w64-$compiler_env-sfml \
    mingw-w64-$compiler_env-hidapi \
    mingw-w64-$compiler_env-glew \
    mingw-w64-$compiler_env-snappy \
    mingw-w64-$compiler_env-libzip \
    mingw-w64-$compiler_env-python \
    mingw-w64-$compiler_env-python-pip \
    mingw-w64-$compiler_env-ccache \
    mingw-w64-$compiler_env-rust \
    mingw-w64-$compiler_env-glm \
    mingw-w64-$compiler_env-libutf8proc \
    mingw-w64-$compiler_env-portmidi \
    mingw-w64-$compiler_env-asio \
    mingw-w64-$compiler_env-faad2 \
    mingw-w64-$compiler_env-libmad \
    mingw-w64-$compiler_env-gtk3 \
    mingw-w64-$compiler_env-lua \
    mingw-w64-$compiler_env-mruby \
    mingw-w64-$compiler_env-squirrel
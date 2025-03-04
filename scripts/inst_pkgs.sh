#!/bin/bash -v

pacman -S --needed --noconfirm \
    wget \
    make \
    patch \
    mingw-w64-ucrt-x86_64-7zip \
    mingw-w64-ucrt-x86_64-toolchain \
    mingw-w64-ucrt-x86_64-libc++ \
    mingw-w64-ucrt-x86_64-clang \
    mingw-w64-ucrt-x86_64-cmake \
    mingw-w64-ucrt-x86_64-ntldd \
    mingw-w64-ucrt-x86_64-libxml2 \
    mingw-w64-ucrt-x86_64-freetype \
    mingw-w64-ucrt-x86_64-ffmpeg \
    mingw-w64-ucrt-x86_64-flac \
    mingw-w64-ucrt-x86_64-drmingw \
    mingw-w64-ucrt-x86_64-mbedtls \
    mingw-w64-ucrt-x86_64-glslang \
    mingw-w64-ucrt-x86_64-spirv-tools \
    mingw-w64-ucrt-x86_64-libusb \
    mingw-w64-ucrt-x86_64-miniupnpc \
    mingw-w64-ucrt-x86_64-SDL \
	mingw-w64-ucrt-x86_64-SDL_image \
	mingw-w64-ucrt-x86_64-SDL_net \
    mingw-w64-ucrt-x86_64-SDL2 \
    mingw-w64-ucrt-x86_64-SDL2_image \
    mingw-w64-ucrt-x86_64-nasm \
	mingw-w64-ucrt-x86_64-ninja \
	mingw-w64-ucrt-x86_64-dlfcn \
	mingw-w64-ucrt-x86_64-libsndfile \
	mingw-w64-ucrt-x86_64-fluidsynth \
	mingw-w64-ucrt-x86_64-fmt \
    mingw-w64-ucrt-x86_64-boost \
    mingw-w64-ucrt-x86_64-nvidia-cg-toolkit \
    mingw-w64-ucrt-x86_64-FAudio \
    mingw-w64-ucrt-x86_64-directx-headers \
    mingw-w64-ucrt-x86_64-directxtk \
    mingw-w64-ucrt-x86_64-angleproject \
    mingw-w64-ucrt-x86_64-qt6 \
    mingw-w64-ucrt-x86_64-openssl
#    mingw-w64-ucrt-x86_64-qt-creator
#    mingw-w64-ucrt-x86_64-python2 \    
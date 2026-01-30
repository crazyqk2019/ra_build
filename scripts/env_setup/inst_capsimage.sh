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

error_message()
{
    $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
}

message()
{
   $SETCOLOR_GREEN && echo "$@" && $SETCOLOR_NORMAL
}

inst_5.1() {
    message "编译安装capsimage 5.1..."
    if [ ! -d capsimg_source_linux_macosx ]; then
        message "解压源文件..."
        7z x capsimg_source_linux_macosx.7z || return $?
        echo
    fi
    cd capsimg_source_linux_macosx/CAPSImg
    message "运行autoconf..."
    autoconf || return $?
    echo
    message "运行configure..."
    ./configure || return $?
    echo
    message "清理..."
    make clean || return $?
    echo
    message "编译..."
    make -j`nproc` || return $?
    echo
    message "安装运行库和链接库..."
    install -v capsimg.dll "$MINGW_PREFIX/bin" || return $?
    install -v capsimg.dll.a "$MINGW_PREFIX/lib" || return $?
    echo
    message "安装头文件..."
    if [ ! -d "$MINGW_PREFIX/include/caps5" ]; then mkdir "$MINGW_PREFIX/include/caps5"; fi
    install -v -D ../LibIPF/*.h "$MINGW_PREFIX/include/caps5/" || return $?
    install -v -D ../Core/CommonTypes.h "$MINGW_PREFIX/include/caps5/CommonTypes.h" || return $?
    cd ../..
    rm -r -f capsimg_source_linux_macosx
    echo "完成"
    echo
}

inst_4.2() {
    message "安装capimage 4.2头文件..."
    if [ ! -d x86_64-linux-gnu-capsimage ]; then
        7z x x86_64-linux-gnu-capsimage.7z  || return $?
    fi
    cd x86_64-linux-gnu-capsimage
    if [ ! -d "$MINGW_PREFIX/include/caps" ]; then mkdir "$MINGW_PREFIX/include/caps"; fi
    install -v -D include/caps/*.h "$MINGW_PREFIX/include/caps/"  || return $?
    cd ..
    rm -r -f x86_64-linux-gnu-capsimage
    echo "完成"
    echo
}

cd "$(dirname "$0")"
cd ./libs
pushd . >/dev/null
inst_5.1 || die "安装出错！"
popd >/dev/null
inst_4.2 || die "安装出错！"
exit 0

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
   #echo ""
   #$SETCOLOR_GREEN && echo "================================" && $SETCOLOR_NORMAL
   $SETCOLOR_GREEN && echo "$@" && $SETCOLOR_NORMAL
   #$SETCOLOR_GREEN && echo "================================" && $SETCOLOR_NORMAL
}

function_exists() {
    declare -F "$1" > /dev/null
    return $?
}

disable_warnings="-Wno-template-id-cdtor -Wno-class-memaccess -Wno-narrowing"

common_build_make() {
    local core_name=$1
    local core=$2
    local core_src=${3:-"."}
    local core_output=$core"_libretro.dll"
    
    echo core_name=$core_name
    echo core=$core
    echo core_src=$core_src
    echo core_output=$core_output
    
    cd libretro-$core/$core_src
    local make_file="Makefile"
    if [ -f Makefile.libretro ]; then
        make_file="Makefile.libretro"
    elif [ -f makefile.libretro ]; then
        make_file="makefile.libretro"
    fi
    if [ -z "$do_not_clean" ]; then
        message "清理 \"$core_name\"..."
        make -f $make_file $add_make_param clean || die "编译出错！"
    fi
    echo "编译 \"$core_name\"..."
    ccache make -f $make_file -j`nproc` $add_make_param || die "编译出错！"
    strip -s $core_output
    cp -v $core_output ../dist/
    message "\"$core_name\" 编译完成。"
    echo
}

build_mame2000() {
    common_build_make "MAME 2000" "mame2000"
}

build_mame2003_plus() {
    common_build_make "MAME 2003 Plus" "mame2003_plus"
}

build_mame2010() {
    common_build_make "MAME 2010" "mame2010"
}

build_mame2015() {
    add_make_param="CC=g++"
    common_build_make "MAME 2015" "mame2015"
    add_make_param=""
}

build_mame2016() {
    add_make_param="MINGW64=/ucrt64 PYTHON_EXECUTABLE=python3"
    common_build_make "MAME 2016" "mame2016"
    add_make_param=""
}

build_mame() {
    (
        add_make_param="MINGW64=/ucrt64 PYTHON_EXECUTABLE=python3"
        common_build_make "MAME" "mame"
    )
}

build_fbalpha2012() {
    (
        export add_make_param="PYTHON_EXECUTABLE=python3"
        common_build_make "Final Burn Alpha 2012" "fbalpha2012" "svn-current/trunk"
    )
}

if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "-noclean" ]; then
    do_not_clean=1
    shift
fi

if [ $# -lt 1 ]; then
    echo "需要指定内核名称！可用内核："
    declare -F | grep -i "\-f build_" | cut -d" " -f3 | cut -d"_" -f2-
    echo
    echo "示例："
    echo "# 编译指定内核："
    echo "./build_cores.sh [-noclean] 内核1 内核2"
    echo "# 编译所有内核："
    echo "./build_cores.sh [-noclean] all"
    exit 1
fi

pushd $(dirname "$0") >/dev/null
cd ..
if [ ! -d cores ]; then
    mkdir cores &>/dev/null
fi
cd cores
if [ ! -d dist ]; then
    mkdir dist &>/dev/null
fi

export PATH=/ucrt/lib/ccache/bin:$PATH

if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "all" ]; then
    for core in $(declare -F | grep -i "\-f build_" | cut -d" " -f3 | cut -d"_" -f2-); do 
        if [ ! -d "libretro-$core" ]; then
            message "内核目录不存在，请先拉取内核源代码：$core"
            echo
        else
            build_$core || (popd &>/dev/null && exit 1)
        fi
    done
else
    while [ $# -gt 0 ]; do
        if function_exists "build_$1"; then
            if [ ! -d "libretro-$1" ]; then
                die "内核目录不存在，请先拉取内核源代码：$1"
                echo
            fi
            build_$1 || (popd &>/dev/null && exit 1)
        else
            die "参数错误，内核不存在：$1"
            echo
        fi
        shift
    done
fi

popd &>/dev/null
message "全部完成。"
exit 0

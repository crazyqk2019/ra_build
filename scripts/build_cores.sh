#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_RED="echo -en \\E[1;31m"
SETCOLOR_NORMAL="echo -en \\E[0m"

die()
{
    if [ $# -gt 0 ]; then
        $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
    fi
    popd &>/dev/null
    exit 1
}

error_message()
{
    if [ $# -gt 0 ]; then
        $SETCOLOR_RED && echo "$@" && $SETCOLOR_NORMAL
    fi
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

cxx_disabled_warnings="-Wno-misleading-indentation -Wno-template-id-cdtor -Wno-class-memaccess -Wno-narrowing -Wno-cast-user-defined"
c_disabled_warnings="-Wno-misleading-indentation -Wno-multichar -Wno-attributes"
cpp_disabled_warnings="-Wno-undef -Wno-misleading-indentation"

# 参数说明：
# $1 - 内核显示名称
# $2 - 内核名称
# $3 - 编译源代码路径（Make文件路径），默认为内核源代码根目录
# $4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
# $5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
common_build_make() {
    local core_name=$1
    local core=$2
    local core_src=${3:-"."}
    local core_dest=${4:-"."}
    local core_output=${5:-$core"_libretro.dll"}
    
    cd "libretro-$core/$core_src"
    
    local make_file="Makefile"
    if [ -f "Makefile.libretro" ]; then
        make_file="Makefile.libretro"
    elif [ -f "makefile.libretro" ]; then
        make_file="makefile.libretro"
    elif [ -f "GNUmakefile" ]; then
        make_file="GNUmakefile"
    fi
    (
        if [ -z "$CXXFLAGS" ]; then CXXFLAGS=" $cxx_disable_warnings"; else CXXFLAGS+=" $cxx_disable_warnings"; fi
        export CXXFLAGS
        if [ -z $CFLAGS ]; then CFLAGS=" $c_disabled_warnings"; else CFLAGS+=" $c_disabled_warnings"; fi
        export CFLAGS
        if [ -z $CPPFLAGS ]; then CPPFLAGS=" $cpp_disabled_warnings"; else CPPFLAGS+=" $cpp_disabled_warnings"; fi
        export CPPFLAGS
        
        if [ -z "$do_not_clean" ]; then
            message "清理 \"$core_name\" (make -f $make_file $make_params -j`nproc` clean)..."
            make -f $make_file $make_params -j`nproc` clean || return $?
            echo
        fi
        
        if [ -z "$no_ccache" ]; then
            message "编译 \"$core_name\" (ccache make -f $make_file $make_params -j`nproc`)..."
            ccache make -f $make_file $make_params -j`nproc` || return $?
        else
            message "编译 \"$core_name\" (make -f $make_file $make_params -j`nproc`)..."
            make -f $make_file $make_params -j`nproc` || return $?
        fi
        echo
        strip -s "$core_dest/$core_output" || return $?
        cp -v "$core_dest/$core_output" "$dists_dir/" || return $?
        return 0
    )
    if [ $? -ne 0 ]; then error_message "\"$core_name\" 编译出错！"; return 1; fi
    
    strip -s "$core_dest/$core_output"
    cp -v "$core_dest/$core_output" "$dists_dir/"
    
    message "\"$core_name\" 编译完成。"
    echo
    return 0
}

# 参数说明：
# $1 - 内核显示名称
# $2 - 内核名称
# $3 - 编译源代码路径（Make文件路径），默认为内核源代码根目录
# $4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
# $5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
common_build_cmake() {
    local core_name=$1
    local core=$2
    local core_src=${3:-"."}
    local core_dest=${4:-"."}
    local core_output=${5:-$core"_libretro.dll"}

    cd "libretro-$core/$core_src"

    (
        if [ -z "$do_not_clean" ]; then
            message "清理 \"$core_name\" (rm -r -f Build Binary)..."
            rm -r -f Build Binary
            echo
        fi
        message "生成 Build 文件 (cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release $cmake_params . -B Build)..."
        cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release $cmake_params . -B Build || return $?
        echo
        message "编译 \"$core_name\" (cmake --build Build --target $core"_libretro" --config Release -- -j`nproc`)..."
        cmake --build Build --target $core"_libretro" --config Release -- -j`nproc` || return $?
        echo
        strip -s "$core_dest/$core_output" || return $?
        cp -v "$core_dest/$core_output" "$dists_dir/" || return $?
        return 0
    )
    
    if [ $? -ne 0 ]; then error_message "编译出错！"; return 1; fi

    message "\"$core_name\" 编译完成。"
    echo
    return 0
}

# Cores built using msys make
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
     local make_params="CC=g++"
     common_build_make "MAME 2015" "mame2015"
}

build_mame2016() {
     local make_params="MINGW64=/ucrt64 PYTHON_EXECUTABLE=python3"
     common_build_make "MAME 2016" "mame2016"
}

build_mame() {
     local make_params="MINGW64=/ucrt64 PYTHON_EXECUTABLE=python3"
     common_build_make "MAME" "mame"
}

build_fbalpha2012() {
     local CFLAGS="-Wno-incompatible-pointer-types"
     common_build_make "Final Burn Alpha 2012" "fbalpha2012" "svn-current/trunk"
}

build_fbalpha2012_cps1() {
    common_build_make "Final Burn Alpha 2012 CPS1" "fbalpha2012_cps1"
}

build_fbalpha2012_cps2() {
    common_build_make "Final Burn Alpha 2012 CPS2" "fbalpha2012_cps2"
}

build_fbalpha2012_cps3() {
    common_build_make "Final Burn Alpha 2012 CPS3" "fbalpha2012_cps3" "svn-current/trunk"
}

build_fbalpha2012_neogeo() {
    local CFLAGS="-Wno-incompatible-pointer-types"
    common_build_make "Final Burn Alpha 2012 Neo Geo" "fbalpha2012_neogeo"
}

build_fbneo() {
    common_build_make "Final Burn Neo" "fbneo" "src/burner/libretro"
}

build_sameboy() {
    common_build_make "SameBoy" "sameboy" "libretro"
}

build_gearboy() {
    common_build_make "Gearboy" "gearboy" "platforms/libretro"
}

build_tgbdual() {
    common_build_make "TGB Dual" "tgbdual"
}

build_mgba() {
    common_build_make "mGBA" "mgba"
}

build_fceumm() {
    common_build_make "FCEUmm" "fceumm"
}

build_nestopia() {
    common_build_make "Nestopia" "nestopia" "libretro"
}

build_bsnes() {
    local make_params="target=libretro binary=library local=false"
    common_build_make "bsnes" "bsnes" "bsnes" "out"
}

build_bsnes_mercury() {
    local make_params="PROFILE=accuracy"
    common_build_make "bsnes mercury accuracy" "bsnes_mercury" "." "." "bsnes_mercury_accuracy_libretro.dll" || return 1
    local make_params="PROFILE=balanced"
    common_build_make "bsnes mercury balanced" "bsnes_mercury" "." "." "bsnes_mercury_balanced_libretro.dll" || return 1
    local make_params="PROFILE=performance"
    common_build_make "bsnes mercury performance" "bsnes_mercury" "." "." "bsnes_mercury_performance_libretro.dll" || return 1
}

build_bsnes2014() {
    local make_params="PROFILE=accuracy"
    common_build_make "bsnes 2014 accuracy" "bsnes2014" "." "." "bsnes2014_accuracy_libretro.dll" || return 1
    local make_params="PROFILE=balanced"
    common_build_make "bsnes 2014 balanced" "bsnes2014" "." "." "bsnes2014_balanced_libretro.dll" || return 1
    local make_params="PROFILE=performance"
    common_build_make "bsnes 2014 performance" "bsnes2014" "." "." "bsnes2014_performance_libretro.dll" || return 1
}

build_bsnes_hd() {
    local make_params="target=libretro binary=library"
    common_build_make "bsnes hd" "bsnes_hd" "bsnes" "out" "bsnes_hd_beta_libretro.dll"
}

build_bsnes_jg() {
    common_build_make "bsnes jg" "bsnes_jg" "libretro" "." "bsnes-jg_libretro.dll"
}

build_snes9x() {
    common_build_make "Snes9x" "snes9x" "libretro"
}

build_mupen64plus_next() {
    common_build_make "Mupen64Plus-Next" "mupen64plus_next"
}

build_parallel_n64() {
    local make_params="HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64"
    common_build_make "ParaLLEl N64" "parallel_n64"
}

build_desmume() {
    common_build_make "DeSmuME" "desmume" "desmume/src/frontend/libretro"
}

build_genesis_plus_gx() {
    common_build_make "Genesis Plus GX" "genesis_plus_gx"
}

build_genesis_plus_gx_wide() {
    common_build_make "Genesis Plus GX Wide" "genesis_plus_gx_wide"
}

build_picodrive() {
    common_build_make "PicoDrive" "picodrive"
}

build_mednafen_saturn() {
    common_build_make "Beetle Saturn" "mednafen_saturn"
}

build_kronos() {
    common_build_make "Kronos" "kronos" "yabause/src/libretro"
}

build_flycast() {
    common_build_make "Kronos" "kronos" "yabause/src/libretro"
}

build_mednafen_psx() {
   local do_not_clean=""
   common_build_make "Beetle PSX" "mednafen_psx" || return $?
   local make_params="HAVE_HW=1"
   common_build_make "Beetle PSX HW" "mednafen_psx" "." "." "mednafen_psx_hw_libretro.dll"
}

build_pcsx_rearmed() {
    common_build_make "PCSX ReARMed" "pcsx_rearmed"
}

build_mednafen_ngp() {
    common_build_make "Beetle NeoPop" "mednafen_ngp"
}

build_neocd() {
    common_build_make "NeoCD" "neocd"
}

build_opera() {
    common_build_make "Opera" "opera"
}

build_mednafen_pce() {
    common_build_make "Beetle PCE" "mednafen_pce"
}

build_mednafen_pce_fast() {
    common_build_make "Beetle PCE Fast" "mednafen_pce_fast"
}

build_fmsx() {
    common_build_make "fMSX" "fmsx"
}

build_px68k() {
    common_build_make "PX68k" "px68k"
}

build_dosbox_core() {
    local make_params="BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1"
    (
        cd libretro-dosbox_core/libretro
        if [ -z "$do_not_clean" ]; then
            message "清理 \"DOSBox Core\" (make -f $make_file $make_params -j`nproc` clean)..."
            make $make_params -j`nproc` clean || return $?
            echo
        fi
        message "编译依赖库 (make -f $make_file $make_params -j`nproc` deps)..."
        make $make_params -j`nproc` deps || return $?
        return 0
    )
    if [ $? -ne 0 ]; then error_message "编译依赖库出错！"; return 1; fi
    
    local do_not_clean=1
    local no_ccache=1
    common_build_make "DOSBox Core" "dosbox_core" "libretro"
}

build_dosbox_pure() {
    local make_params="platform=windows"
    common_build_make "DOSBox Pure" "dosbox_pure"
}

# Cores built using cmake
build_dolphin() {
    (
        cd libretro-dolphin
        if [ -z "$do_not_clean" ]; then
            message "清理 \"dxsdk\"..."
            rm -f Externals/dxsdk/lib/x86/*.a
            rm -f Externals/dxsdk/lib/x64/*.a
            echo
        fi
        message "编译 \"dxsdk\"..."
        make -C Externals/dxsdk/lib DLLTOOL=dlltool || return $?
        return 0
    )
    if [ $? -ne 0 ]; then error_message "编译 \"dxsdk\" 出错！"; return 1; fi
    
    local cmake_params="-DLIBRETRO=ON"
    common_build_cmake "Dolphin" "dolphin" "." "Binary"
}

build_melondsds() {
    common_build_cmake "melonDS DS" "melondsds" "." "Build/src/libretro"
}

build_citra() {
    local cmake_params="-DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF"
    common_build_cmake "Citra" "citra" "." "Build/bin/Release"
}

build_flycast() {
    local cmake_params="-DLIBRETRO=ON"
    common_build_cmake "PPSSPP" "ppsspp" "." "Build"
}

build_ppsspp() {
    (
        cd libretro-ppsspp
        message "Patching \"ext/glslang/glslang/MachineIndependent/SymbolTable.h\""...
        grep -i "cstdint" ext/glslang/glslang/MachineIndependent/SymbolTable.h
        if [ $? -ne 0 ]; then
            sed -i '0,/#include/{s/#include/#include <cstdint>\n#include/}' ext/glslang/glslang/MachineIndependent/SymbolTable.h || return $?
        fi
        echo
        message "Update glslang external sources..."
        cd ext/glslang
        ./update_glslang_sources.py || return $?
        echo
        return 0
    )
    if [ $? -ne 0 ]; then error_message "Patching file failed!"; return 1; fi
    echo
    
    # local cmake_params="-DLIBRETRO=ON -DUSE_SYSTEM_SNAPPY=ON -DUSE_SYSTEM_FFMPEG=ON -DUSE_SYSTEM_LIBZIP=ON -DUSE_SYSTEM_LIBSDL2=ON -DUSE_SYSTEM_LIBPNG=ON -DUSE_SYSTEM_ZSTD=ON -DUSE_SYSTEM_MINIUPNPC=ON"
    local cmake_params="-DLIBRETRO=ON"
    common_build_cmake "PPSSPP" "ppsspp" "." "Build"
}

do_not_clean=""
no_ccache=""
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
if [ ! -d cores ]; then mkdir cores >/dev/null; fi
cores_dir="$PWD/cores"
cd cores
if [ ! -d dists ]; then mkdir dists >/dev/null; fi
dists_dir="$PWD/dists"

export PATH=/ucrt/lib/ccache/bin:$PATH
if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "all" ]; then
    for core in $(declare -F | grep -i "\-f build_" | cut -d" " -f3 | cut -d"_" -f2-); do 
        cd "$cores_dir"
        if [ ! -d "libretro-$core" ]; then
            error_message "内核目录不存在，请先拉取内核源代码：\"$core\""
            echo
        else
            build_$core || die
        fi
    done
else
    while [ $# -gt 0 ]; do
        if function_exists "build_$1"; then
            cd "$cores_dir"
            if [ ! -d "libretro-$1" ]; then
                error_message "内核目录不存在，请先拉取内核源代码：\"$1\""
                echo
            else
                build_$1 || die
            fi
        else
            die "参数错误，内核不存在：\"$1\""
        fi
        shift
    done
fi

popd &>/dev/null
message "全部完成。"
exit 0

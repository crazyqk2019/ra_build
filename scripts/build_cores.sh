#!/bin/bash

export PATH=/ucrt/lib/ccache/bin:$PATH

cd "$(dirname "$0")"
cd ..
if [ ! -d cores/dists ]; then mkdir -p cores/dists >/dev/null; fi
cores_dir="$PWD/cores"
dists_dir="$PWD/cores/dists"

no_clean=""
no_ccache=""
if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "-noclean" ]; then
    no_clean=1
    shift
fi

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

function_exists() {
    declare -F "$1" > /dev/null
    return $?
}

c_disabled_warnings="-Wno-misleading-indentation -Wno-multichar -Wno-attributes"
cxx_disabled_warnings="-Wno-misleading-indentation -Wno-template-id-cdtor -Wno-class-memaccess -Wno-narrowing -Wno-cast-user-defined"
cpp_disabled_warnings="-Wno-undef -Wno-misleading-indentation"

# 使用make编译通用方法，参数说明：
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
    
    cd "$cores_dir/libretro-$core/$core_src"
    
    local make_file="Makefile"
    if [ -f "Makefile.libretro" ]; then
        make_file="Makefile.libretro"
    elif [ -f "GNUmakefile" ]; then
        make_file="GNUmakefile"
    fi
    
    (
        if [ -z "$CXXFLAGS" ]; then CXXFLAGS=" $cxx_disable_warnings"; else CXXFLAGS+=" $cxx_disable_warnings"; fi
        if [ -z "$CFLAGS" ]; then CFLAGS=" $c_disabled_warnings"; else CFLAGS+=" $c_disabled_warnings"; fi
        if [ -z "$CPPFLAGS" ]; then CPPFLAGS=" $cpp_disabled_warnings"; else CPPFLAGS+=" $cpp_disabled_warnings"; fi
        export CFLAGS
        export CXXFLAGS
        export CPPFLAGS
        
        if [ -z "$no_clean" ]; then
            message "清理 \"$core_name\" (make -f $make_file -j`nproc` $make_params clean)..."
            make -f $make_file -j`nproc` $make_params clean || return $?
            echo
        fi

        if [ -z "$no_ccache" ]; then
            message "编译 \"$core_name\" (ccache make -f $make_file -j`nproc` $make_params)..."
            ccache make -f $make_file -j`nproc` $make_params || return $?
        else
            message "编译 \"$core_name\" (make -f $make_file -j`nproc` $make_params)..."
            make -f $make_file -j`nproc` $make_params || return $?
        fi
        echo
        
        strip -s "$core_dest/$core_output" || return $?
        cp -v "$core_dest/$core_output" "$dists_dir/" || return $?
        echo
    )
    
    if [ $? -ne 0 ]; then error_message "\"$core_name\" 编译出错！"; return 1; fi
  
    message "\"$core_name\" 编译完成。"
    echo
    
    return 0
}

# 使用cmake编译通用方法，参数说明：
# $1 - 内核显示名称
# $2 - 内核名称
# $3 - 编译源代码路径（Make文件路径），默认为内核源代码根目录
# $4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
# $5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
# $6 - 指定编译目录，默认为Build
common_build_cmake() {
    local core_name=$1
    local core=$2
    local core_src=${3:-"."}
    local core_dest=${4:-"."}
    local core_output=${5:-$core"_libretro.dll"}
    local build_dir=${6:-"Build"}
    echo core_output=$core_output
    echo build_dir=$build_dir

    cd "libretro-$core/$core_src"

    (
        if [ -z "$no_clean" ]; then
            if [ -d "$build_dir" ]; then
                message "清理 \"$core_name\" (cmake --build $build_dir --target clean -j`nproc`)..."            
                cmake --build $build_dir --target clean -j`nproc`
                echo
            fi
            message "清理 \"$core_name\"，删除编译目录 (rm -r -f $build_dir)..."
            rm -r -f $build_dir
            echo
        fi
        
        message "生成编译配置文件 (cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -B $build_dir $cmake_params)..."
        cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -B $build_dir $cmake_params || return $?
        echo
        
        message "编译 \"$core_name\" (cmake --build $build_dir --target $core"_libretro" --config Release -j`nproc`)..."
        cmake --build $build_dir --target $core"_libretro" --config Release -j`nproc` || return $?
        echo
        
        strip -s "$core_dest/$core_output" || return $?
        cp -v "$core_dest/$core_output" "$dists_dir/" || return $?
        echo
    )
    
    if [ $? -ne 0 ]; then error_message "编译出错！"; return 1; fi

    message "\"$core_name\" 编译完成。"
    echo
    
    return 0
}

# Cores built using make
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
     local make_params="PYTHON_EXECUTABLE=python3"
     common_build_make "MAME 2016" "mame2016"
}

build_mame() {
     local make_params="PYTHON_EXECUTABLE=python3"
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
    local profiles_list=("accuracy" "balanced" "performance")
    for f in "${profiles_list[@]}"; do
        local make_params="PROFILE=$f"
        common_build_make "bsnes mercury %f" "bsnes_mercury" "." "." "bsnes_mercury_"$f"_libretro.dll" || return 1
    done
}

build_bsnes2014() {
    local profiles_list=("accuracy" "balanced" "performance")
    for f in "${profiles_list[@]}"; do
        local make_params="PROFILE=$f"
        common_build_make "bsnes 2014 %f" "bsnes2014" "." "." "bsnes2014_"$f"_libretro.dll" || return 1
    done
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
   local no_clean=""
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

build_81() {
    common_build_make "ZX81" "81"
}

build_fuse() {
    common_build_make "Fuse" "fuse"
}

build_atari800() {
    common_build_make "Atari800" "atari800"
}

build_stella() {
    common_build_make "Stella" "stella" "src/os/libretro"
}

build_prosystem() {
    common_build_make "ProSystem" "prosystem"
}

build_virtualjaguar() {
    common_build_make "Virtual Jaguar" "virtualjaguar"
}

build_mednafen_lynx() {
    common_build_make "Beetle Lynx" "mednafen_lynx"
}

build_handy() {
    common_build_make "Handy" "handy"
}

build_hatari() {
    common_build_make "Hatari" "hatari"
}

build_bk() {
    common_build_make "bk" "bk"
}

build_blastem() {
    common_build_make "BlastEm" "blastem"
}

build_bluemsx() {
    common_build_make "blueMSX" "bluemsx"
}

build_cap32() {
    common_build_make "Caprice32" "cap32"
}

build_crocods() {
    common_build_make "CrocoDS" "crocods"
}

build_jaxe() {
    common_build_make "JAXE" "jaxe"
}

build_ep128emu_core() {
    local make_params="platform=win64"
    common_build_make "ep128emu" "ep128emu_core"
}

build_freeintv() {
    common_build_make "FreeIntv" "freeintv"
}

build_gambatte() {
    common_build_make "Gambatte" "gambatte"
}

build_gearcoleco() {
    common_build_make "GearColeco" "gearcoleco" "platforms/libretro"
}

build_gearsystem() {
    common_build_make "Gearsystem" "gearsystem" "platforms/libretro"
}

build_gpsp() {
    common_build_make "gpSP" "gpsp"
}

build_gw() {
    common_build_make "GW" "gw"
}

build_hbmame() {
    local make_params="PYTHON_EXECUTABLE=python3"
    Nmake_params+=" O_USE_MIDI=0 NO_USE_PORTAUDIO=0" 
    make_params+=" USE_SYSTEM_LIB_EXPAT=1 USE_SYSTEM_LIB_ZLIB=1 USE_SYSTEM_LIB_JPEG=1 USE_SYSTEM_LIB_FLAC=1 USE_SYSTEM_LIB_SQLITE3=1 USE_SYSTEM_LIB_PORTMIDI=1 USE_SYSTEM_LIB_PORTAUDIO=1 USE_SYSTEM_LIB_UTF8PROC=1 USE_SYSTEM_LIB_GLM=1 USE_SYSTEM_LIB_RAPIDJSON=1 USE_SYSTEM_LIB_PUGIXML=1"
    make_params+=" USE_BUNDLED_LIB_SDL2=0"
    common_build_make "HBMAME" "hbmame"
}

build_mednafen_gba() {
    common_build_make "Beetle GBA" "mednafen_gba"
}

build_mednafen_pcfx() {
    common_build_make "Beetle PC-FX" "mednafen_pcfx"
}

build_mednafen_supergrafx() {
    common_build_make "Beetle SuperGrafx" "mednafen_supergrafx"
}

build_mednafen_vb() {
    common_build_make "Beetle VB" "mednafen_vb"
}

build_mednafen_wswan() {
    common_build_make "Beetle Cygne" "mednafen_wswan"
}

build_meteor() {
    common_build_make "Meteor" "meteor" "libretro"
}

build_np2kai() {
    local CFLAGS="-Wno-incompatible-pointer-types"
    common_build_make "Neko Project II Kai" "np2kai" "sdl"
}

build_numero() {
    common_build_make "Numero" "numero"
}

build_o2em() {
    common_build_make "O2EM" "o2em"
}

build_oberon() {
    common_build_make "Oberon" "oberon"
}

build_pokemini() {
    common_build_make "PokeMini" "pokemini"
}

build_potator() {
    common_build_make "Potator" "potator" "platform/libretro"
}

build_vice() {
    pushd "$cores_dir/libretro-vice" >/dev/null
    local emutype_list=( $(ls Makefile.* | cut -d"." -f2 | grep -v -i "common") )
    popd
    for t in "${emutype_list[@]}"; do
        local make_params="EMUTYPE=$t"
        common_build_make "VICE $t" "vice" "." "." "vice_"$t"_libretro.dll" || return 1
    done
}

build_puae() {
    common_build_make "PUAE" "puae"
}

build_quasi88() {
    common_build_make "QUASI88" "quasi88"
}

build_quicknes() {
    common_build_make "QuickNES" "quicknes"
}

build_race() {
    common_build_make "RACE" "race"
}

build_same_cdi() {
    common_build_make "SAME_CDI" "same_cdi"
}

build_sameduck() {
    common_build_make "SameDuck" "sameduck" "libretro"
}

build_scummvm() {
    local make_params="USE_SYSTEM_fluidsynth=1 USE_SYSTEM_FLAC=1 USE_SYSTEM_vorbis=1 USE_SYSTEM_z=1 USE_SYSTEM_mad=1 USE_SYSTEM_faad=1 USE_SYSTEM_png=1 USE_SYSTEM_jpeg=1 USE_SYSTEM_theora=1 USE_SYSTEM_freetype=1 USE_SYSTEM_fribidi=1"
    common_build_make "ScummVM" "scummvm" "backends\platform\libretro"
}

build_smsplus() {
    common_build_make "SMS Plus GX" "smsplus"
}

build_theodore() {
    common_build_make "Theodore" "theodore"
}

build_uw8() {
    common_build_make "MicroW8" "uw8"
}

build_uzem() {
    common_build_make "Uzem" "uzem"
}

build_vbam() {
    common_build_make "VBA-M" "vbam" "src/libretro"
}

build_vba_next() {
    common_build_make "VBA Next" "vba_next"
}

build_vecx() {
    common_build_make "vecx" "vecx"
}

build_x1() {
    common_build_make "Sharp X1" "x1" "libretro"
}

build_dosbox_core() {
    local make_params="BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1"
    (
        cd "cores_dir/libretro-dosbox_core/libretro"
        if [ -z "$no_clean" ]; then
            message "清理 \"DOSBox Core\" (make -f $make_file $make_params -j`nproc` clean)..."
            make $make_params -j`nproc` clean || return $?
            echo
        fi
        message "编译依赖库 (make -f $make_file $make_params -j`nproc` deps)..."
        make $make_params -j`nproc` deps || return $?
        return 0
    )
    if [ $? -ne 0 ]; then error_message "编译依赖库出错！"; return 1; fi
    
    local no_clean=1
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
        cd "cores_dir/libretro-dolphin"
        if [ -z "$no_clean" ]; then
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
        cd "cores_dir/libretro-ppsspp"
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

build_squirreljme() {
    local cmake_params="-DRETROARCH=ON -DSQUIRRELJME_ENABLE_TESTING=OFF"
    common_build_cmake "SquirrelJME" "squirreljme" "nanocoat" "Build"
}

build_tic80() {
    local cmake_params="-DBUILD_SDLGPU=On -DBUILD_WITH_ALL=On -DBUILD_LIBRETRO=ON -DPREFER_SYSTEM_LIBRARIES=ON"
    common_build_cmake "TIC-80" "tic80" "." "Build1/lib" "" "Build1"
}


build_holani() {
    cd "$cores_dir/libretro-holani"
    (
        cargo build --release || return $?
        strip -s target/release/holani.dll || return $?
        cp -v target/release/holani.dll "$dists_dir/holani_libretro.dll" || return $?
    )
    if [ $? -ne 0 ]; then "编译 \"Holani\" 出错！"; return 1; fi
    message "\"Holani\" 编译完成。";echo
}


if [ $# -lt 1 ]; then
    message "需要指定内核名称！可用内核："
    declare -F | grep -i "\-f build_" | cut -d" " -f3 | cut -d"_" -f2-
    echo
    message "示例："
    message "# 编译指定内核："
    echo "./build_cores.sh [-noclean] core1 core2"
    message "# 编译所有内核："
    echo "./build_cores.sh [-noclean] all"
    exit 1
fi

cd "$cores_dir"
if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "all" ]; then
    for core in $(declare -F | grep -i "\-f build_" | cut -d" " -f3 | cut -d"_" -f2-); do 
        if [ ! -d "libretro-$core" ]; then
            error_message "内核 \"$core\" 源代码目录不存在，跳过编译。";echo
        else
            pushd . >/dev/null
            build_$core || die
            popd >/dev/null
        fi
    done
else
    cores_list=()
    while [ $# -gt 0 ]; do
        if ! function_exists "build_$1"; then
            die "参数错误，内核 \"$1\" 不存在！"
        elif [ ! -d "libretro-$1" ]; then
            error_message "内核 \"$1\" 源代码目录不存在，跳过编译。"
        else
            cores_list+=("$1")
        fi
        shift
    done
    echo
    for core in "${cores_list[@]}"; do
        pushd . >/dev/null
        build_$core || die
        popd >/dev/null
    done
fi

message "全部编译完成。"
exit 0

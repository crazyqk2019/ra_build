#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"; SETCOLOR_RED="echo -en \\E[1;31m"; SETCOLOR_NORMAL="echo -en \\E[0;39m"
message(){ $SETCOLOR_GREEN; echo "$@"; $SETCOLOR_NORMAL; }
error_message() { $SETCOLOR_RED; echo "$@"; $SETCOLOR_NORMAL; }
die() { if [ $# -gt 0 ]; then error_message "$@"; fi; exit 1; }

# Cores built using make
build_mame2000() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "MAME 2000" "mame2000"
}

build_mame2003_plus() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "MAME 2003 Plus" "mame2003_plus"
}

build_mame2010() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "MAME 2010" "mame2010"
}

build_mame2015() {
    local make_params="CC=g++"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "MAME 2015" "mame2015"
}

build_mame2016() {
    local make_params="PYTHON_EXECUTABLE=python3"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "MAME 2016" "mame2016"
}

build_mame() {
    local make_params="PYTHON_EXECUTABLE=python3"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "MAME" "mame"
}

build_fbalpha2012() {
    if [[ ! -v CFLAGS ]]; then
        local MY_CFLAGS="-Wno-incompatible-pointer-types"
    else
        local MY_CFLAGS=$CFLAGS + " -Wno-incompatible-pointer-types"
    fi
    no_clean=$no_clean no_ccache=$no_ccache CFLAGS=$MY_CFLAGS ./build_use_make.sh "Final Burn Alpha 2012" "fbalpha2012" "svn-current/trunk"
}

build_fbalpha2012_cps1() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Final Burn Alpha 2012 CPS1" "fbalpha2012_cps1"
}

build_fbalpha2012_cps2() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Final Burn Alpha 2012 CPS2" "fbalpha2012_cps2"
}

build_fbalpha2012_cps3() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Final Burn Alpha 2012 CPS3" "fbalpha2012_cps3" "svn-current/trunk"
}

build_fbalpha2012_neogeo() {
    if [[ ! -v CFLAGS ]]; then
        local MY_CFLAGS="-Wno-incompatible-pointer-types"
    else
        local MY_CFLAGS=$CFLAGS + " -Wno-incompatible-pointer-types"
    fi    
    no_clean=$no_clean no_ccache=$no_ccache CFLAGS=$MY_CFLAGS ./build_use_make.sh "Final Burn Alpha 2012 Neo Geo" "fbalpha2012_neogeo"
}

build_fbneo() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Final Burn Neo" "fbneo" "src/burner/libretro"
}

build_sameboy() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "SameBoy" "sameboy" "libretro"
}

build_gearboy() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Gearboy" "gearboy" "platforms/libretro"
}

build_tgbdual() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "TGB Dual" "tgbdual"
}

build_mgba() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "mGBA" "mgba"
}

build_fceumm() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "FCEUmm" "fceumm"
}

build_nestopia() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Nestopia" "nestopia" "libretro"
}

build_bsnes() {
    local make_params="target=libretro binary=library local=false"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "bsnes" "bsnes" "bsnes" "out"
}

build_bsnes_mercury() {
    local profiles_list=("accuracy" "balanced" "performance")
    for f in "${profiles_list[@]}"; do
        local make_params="PROFILE=$f"
        no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "bsnes mercury %f" "bsnes_mercury" "." "." "bsnes_mercury_"$f"_libretro.dll" || return 1
    done
}

build_bsnes2014() {
    local profiles_list=("accuracy" "balanced" "performance")
    for f in "${profiles_list[@]}"; do
        local make_params="PROFILE=$f"
        no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "bsnes 2014 %f" "bsnes2014" "." "." "bsnes2014_"$f"_libretro.dll" || return 1
    done
}

build_bsnes_hd() {
    local make_params="target=libretro binary=library"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "bsnes hd" "bsnes_hd" "bsnes" "out" "bsnes_hd_beta_libretro.dll"
}

build_bsnes_jg() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "bsnes jg" "bsnes_jg" "libretro" "." "bsnes-jg_libretro.dll"
}

build_snes9x() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Snes9x" "snes9x" "libretro"
}

build_mupen64plus_next() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Mupen64Plus-Next" "mupen64plus_next"
}

build_parallel_n64() {
    local make_params="HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "ParaLLEl N64" "parallel_n64"
}

build_desmume() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "DeSmuME" "desmume" "desmume/src/frontend/libretro"
}

build_genesis_plus_gx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Genesis Plus GX" "genesis_plus_gx"
}

build_genesis_plus_gx_wide() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Genesis Plus GX Wide" "genesis_plus_gx_wide"
}

build_picodrive() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "PicoDrive" "picodrive"
}

build_mednafen_saturn() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle Saturn" "mednafen_saturn"
}

build_kronos() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Kronos" "kronos" "yabause/src/libretro"
}

build_flycast() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Kronos" "kronos" "yabause/src/libretro"
}

build_mednafen_psx() {
   no_ccache=$no_ccache ./build_use_make.sh "Beetle PSX" "mednafen_psx" || return $?
   local make_params="HAVE_HW=1"
   no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "Beetle PSX HW" "mednafen_psx" "." "." "mednafen_psx_hw_libretro.dll"
}

build_pcsx_rearmed() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "PCSX ReARMed" "pcsx_rearmed"
}

build_mednafen_ngp() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle NeoPop" "mednafen_ngp"
}

build_neocd() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "NeoCD" "neocd"
}

build_opera() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Opera" "opera"
}

build_mednafen_pce() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle PCE" "mednafen_pce"
}

build_mednafen_pce_fast() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle PCE Fast" "mednafen_pce_fast"
}

build_fmsx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "fMSX" "fmsx"
}

build_px68k() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "PX68k" "px68k"
}

build_81() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "ZX81" "81"
}

build_fuse() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Fuse" "fuse"
}

build_atari800() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Atari800" "atari800"
}

build_stella() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Stella" "stella" "src/os/libretro"
}

build_prosystem() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "ProSystem" "prosystem"
}

build_virtualjaguar() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Virtual Jaguar" "virtualjaguar"
}

build_mednafen_lynx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle Lynx" "mednafen_lynx"
}

build_handy() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Handy" "handy"
}

build_hatari() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Hatari" "hatari"
}

build_bk() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "bk" "bk"
}

build_blastem() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "BlastEm" "blastem"
}

build_bluemsx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "blueMSX" "bluemsx"
}

build_cap32() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Caprice32" "cap32"
}

build_crocods() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "CrocoDS" "crocods"
}

build_jaxe() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "JAXE" "jaxe"
}

build_ep128emu_core() {
    local make_params="platform=win64"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "ep128emu" "ep128emu_core"
}

build_freeintv() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "FreeIntv" "freeintv"
}

build_gambatte() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Gambatte" "gambatte"
}

build_gearcoleco() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "GearColeco" "gearcoleco" "platforms/libretro"
}

build_gearsystem() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Gearsystem" "gearsystem" "platforms/libretro"
}

build_gpsp() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "gpSP" "gpsp"
}

build_gw() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "GW" "gw"
}

build_hbmame() {
    local make_params="PYTHON_EXECUTABLE=python3"
    make_params+=" NO_USE_MIDI=0 NO_USE_PORTAUDIO=0" 
    make_params+=" USE_SYSTEM_LIB_EXPAT=1 USE_SYSTEM_LIB_ZLIB=1 USE_SYSTEM_LIB_JPEG=1 USE_SYSTEM_LIB_FLAC=1 USE_SYSTEM_LIB_SQLITE3=1 USE_SYSTEM_LIB_PORTMIDI=1 USE_SYSTEM_LIB_PORTAUDIO=1 USE_SYSTEM_LIB_UTF8PROC=1 USE_SYSTEM_LIB_GLM=1 USE_SYSTEM_LIB_RAPIDJSON=1 USE_SYSTEM_LIB_PUGIXML=1"
    make_params+=" USE_BUNDLED_LIB_SDL2=0"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "HBMAME" "hbmame"
}

build_mednafen_gba() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle GBA" "mednafen_gba"
}

build_mednafen_pcfx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle PC-FX" "mednafen_pcfx"
}

build_mednafen_supergrafx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle SuperGrafx" "mednafen_supergrafx"
}

build_mednafen_vb() {
    .no_clean=$no_clean no_ccache=$no_ccache /build_use_make.sh "Beetle VB" "mednafen_vb"
}

build_mednafen_wswan() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Beetle Cygne" "mednafen_wswan"
}

build_meteor() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Meteor" "meteor" "libretro"
}

build_np2kai() {
    if [[ ! -v CFLAGS ]]; then
        local MY_CFLAGS="-Wno-incompatible-pointer-types"
    else
        local MY_CFLAGS=$CFLAGS + " -Wno-incompatible-pointer-types"
    fi
    no_clean=$no_clean no_ccache=$no_ccache CFLAGS=$MY_CFLAGS ./build_use_make.sh "Neko Project II Kai" "np2kai" "sdl"
}

build_numero() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Numero" "numero"
}

build_o2em() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "O2EM" "o2em"
}

build_oberon() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Oberon" "oberon"
}

build_pokemini() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "PokeMini" "pokemini"
}

build_potator() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Potator" "potator" "platform/libretro"
}

build_vice() {
    pushd "$cores_dir/libretro-vice" >/dev/null
    local emutype_list=( $(ls Makefile.* | cut -d"." -f2 | grep -v -i "common") )
    popd
    for t in "${emutype_list[@]}"; do
         no_clean=$no_clean no_ccache=$no_ccache make_params="EMUTYPE=$t" ./build_use_make.sh "VICE $t" "vice" "." "." "vice_"$t"_libretro.dll" || return 1
    done
}

build_puae() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "PUAE" "puae"
}

build_quasi88() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "QUASI88" "quasi88"
}

build_quicknes() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "QuickNES" "quicknes"
}

build_race() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "RACE" "race"
}

build_same_cdi() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "SAME_CDI" "same_cdi"
}

build_sameduck() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "SameDuck" "sameduck" "libretro"
}

build_scummvm() {
    local make_params="USE_SYSTEM_fluidsynth=1 USE_SYSTEM_FLAC=1 USE_SYSTEM_vorbis=1 USE_SYSTEM_z=1 USE_SYSTEM_mad=1 USE_SYSTEM_faad=1 USE_SYSTEM_png=1 USE_SYSTEM_jpeg=1 USE_SYSTEM_theora=1 USE_SYSTEM_freetype=1 USE_SYSTEM_fribidi=1"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "ScummVM" "scummvm" "backends\platform\libretro"
}

build_smsplus() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "SMS Plus GX" "smsplus"
}

build_theodore() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Theodore" "theodore"
}

build_uw8() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "MicroW8" "uw8"
}

build_uzem() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Uzem" "uzem"
}

build_vbam() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "VBA-M" "vbam" "src/libretro"
}

build_vba_next() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "VBA Next" "vba_next"
}

build_vecx() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "vecx" "vecx"
}

build_x1() {
    no_clean=$no_clean no_ccache=$no_ccache ./build_use_make.sh "Sharp X1" "x1" "libretro"
}

build_dosbox_core() {
    local make_params="BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1"
    (
        cd "$cores_dir/libretro-dosbox_core/libretro"
        if [[ ! -v $no_clean ]]; then
            message "清理 \"DOSBox Core\" (make $make_params -j`nproc` clean)..."
            make $make_params -j`nproc` clean
            message "清理 \"DOSBox Core\" 完成。"
            echo
        fi
        message "编译依赖库 (make -f $make_params -j`nproc` deps)..."
        make $make_params -j`nproc` deps || return $?
        return 0
    )
    if [ $? -ne 0 ]; then error_message "编译依赖库出错！"; return 1; fi
    
    no_clean=1 no_ccache=1 make_params=$make_params ./build_use_make.sh "DOSBox Core" "dosbox_core" "libretro"
}

build_dosbox_pure() {
    local make_params="platform=windows"
    no_clean=$no_clean no_ccache=$no_ccache make_params=$make_params ./build_use_make.sh "DOSBox Pure" "dosbox_pure"
}

# Cores built using cmake
build_dolphin() {
    (
        cd "$cores_dir/libretro-dolphin"
        if [[ ! -v $no_clean ]]; then
            message "清理 \"dxsdk\"..."
            rm -f Externals/dxsdk/lib/x86/*.a
            rm -f Externals/dxsdk/lib/x64/*.a
            message "清理 \"dxsdk\"完成。"
            echo
        fi
        message "编译 \"dxsdk\"..."
        make -C Externals/dxsdk/lib DLLTOOL=dlltool || return $?
        return 0
    )
    if [[ $? -ne 0 ]]; then error_message "编译 \"dxsdk\" 出错！"; return 1; fi
    
    local cmake_params="-DLIBRETRO=ON"
    no_clean=$no_clean no_regen=$no_regen cmake_params=$cmake_params ./build_use_cmake.sh "Dolphin" "dolphin" "." "Binary"
}

build_melondsds() {
    no_clean=$no_clean no_regen=$no_regen  cmake_params=-DENABLE_LTO_RELEASE=OFF ./build_use_cmake.sh "melonDS DS" "melondsds" "." "${MSYSTEM,,}_build/src/libretro"
}

build_citra() {
    local cmake_params="-DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF"
    no_clean=$no_clean no_regen=$no_regen cmake_params=$cmake_params ./build_use_cmake.sh "Citra" "citra" "." "${MSYSTEM,,}_build/bin/Release"
}

build_flycast() {
    local cmake_params="-DLIBRETRO=ON"
    no_clean=$no_clean no_regen=$no_regen cmake_params=$cmake_params ./build_use_cmake.sh "PPSSPP" "ppsspp" "." "${MSYSTEM,,}_build"
}

build_ppsspp() {
    (
        cd "$cores_dir/libretro-ppsspp"
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
    no_clean=$no_clean no_regen=$no_regen cmake_params=$cmake_params ./build_use_cmake.sh "PPSSPP" "ppsspp" "." "Build"
}

build_squirreljme() {
    local cmake_params="-DRETROARCH=ON -DSQUIRRELJME_ENABLE_TESTING=OFF"
    no_clean=$no_clean no_regen=$no_regen cmake_params=$cmake_params ./build_use_cmake.sh "SquirrelJME" "squirreljme" "nanocoat" "Build"
}

build_tic80() {
    local cmake_params="-DBUILD_SDLGPU=On -DBUILD_WITH_ALL=On -DBUILD_LIBRETRO=ON -DPREFER_SYSTEM_LIBRARIES=ON"
    no_clean=$no_clean no_regen=$no_regen cmake_params=$cmake_params ./build_use_cmake.sh "TIC-80" "tic80" "." "Build1/lib" "" "Build1"
}

# Cores built using other tools
build_holani() {
    (
        cd "$cores_dir/libretro-holani"
        cargo build --release || return $?
        strip -s target/release/holani.dll || return $?
        cp -v target/release/holani.dll "$dists_dir/holani_libretro.dll" || return $?
    )
    if [ $? -ne 0 ]; then "编译 \"Holani\" 出错！"; return 1; fi
    message "\"Holani\" 编译完成。";echo
}

function_exist() { declare -F "$1" > /dev/null; return $?; }

buildCores() {
     for core in "${build_cores_list[@]}"; do
        if ! function_exist "build_$core"; then error_message "参数错误，内核 \"$core\" 不存在！"; return 1; fi
        if [[ ! -d "$cores_dir/libretro-$core" ]]; then error_message "内核 \"$core\" 源代码目录不存在！"; return 1; fi
        build_$core || { error_message "编译内核 \"$core\" 出错！"; return 1; }
    done
    return 0
}

buildAllCores() {
    for core in $(declare -F | grep -i "\-f clone_" | cut -d" " -f3 | cut -d"_" -f2-); do
        buildCores $core || { error_message "编译内核 \"$core\" 出错！"; return 1; }
    done
}

unset no_clean
unset no_ccache
unset no_regen
unset build_all
build_cores_list=()
while [[ $# -gt 0 ]]; do
    if [[ ${1,,} = "-noclean" ]]; then no_clean=1;
    elif [[ ${1,,} = "-noccache" ]]; then no_ccache=1;
    elif [[ ${1,,} = "-noregen" ]]; then no_regen=1;
    elif [[ ${1,,} = "all" ]]; then build_all=1;
    else build_cores_list+=(${1,,});
    fi
    shift
done

echo "build_all=$build_all"
echo "build_cores_list=${build_cores_list[@]}"

if [[ ! -v $build_all && ${#build_cores_list[@]} -eq 0 ]]; then
    message "需要指定编译内核，或指定 \"all\" 编译所有内核。可用内核列表："
    declare -F | grep -i "\-f build_" | cut -d" " -f3 | cut -d"_" -f2-
    echo
    echo "示例："
    echo "编译指定内核：./build_cores.sh [-noclean] [-noregen] [-noccache] core1 core2"
    echo "编译所有内核：./build_cores.sh [-noclean] [-noregen] [-noccache] all"
    echo "-noclean: 编译前不要执行清理操作"
    echo "-noregen: 对于使用CMake编译的内核，不要重新创建编译配置文件"
    echo "-noccache: 对于使用make编译的内核，不要使用ccache加速编译"
    exit 0
fi

pushd "$(dirname "$0")" >/dev/null

pushd .. >/dev/null
cores_dir="$PWD/cores"
dists_dir="$PWD/cores/dists"
popd >/dev/null
if [[ ! -d $dists_dir ]]; then mkdir -p $dists_dir >/dev/null; die "创建分发目录出错！"; fi

if [[ -v $build_all ]]; then
    buildAllCores
else
    buildCores
fi
if [[ $? -ne 0 ]]; then die; fi

popd &>/dev/null
message "全部编译完成。"
exit 0

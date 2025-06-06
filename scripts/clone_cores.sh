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

common_clone_core() {
    local core_name=$1
    local core=$2
    local core_upstream=$3
    local core_branch=$4
    message "克隆仓库 \"$core_name\" (https://github.com/crazyqk2019/libretro-$core)..."
    git clone --recursive https://github.com/crazyqk2019/libretro-$core
    if [ $? -ne 0 ]; then error_message "克隆仓库出错！"; return 1; fi
    echo
    cd libretro-$core
    message "添加上游仓库 \"$core_name\" (https://github.com/libretro/$core_upstream)..."
    if [[ "$core_upstream" =~ ^https?:// ]]; then
        git remote add upstream $core_upstream
    else
        git remote add upstream https://github.com/libretro/$core_upstream
    fi
    if [ $? -ne 0 ]; then error_message "添加上游仓库出错！"; return 1; fi
    echo
    git config --local user.name crazyqk2019
    git config --local user.email crazyq@gmail.com
    if [ -n "$core_branch" ]; then
        message "切换到分支 \"$core_branch\"..."
        git checkout $core_branch
        if [ $? -ne 0 ]; then error_message "切换分支出错！"; return 1; fi
        echo
    fi
    cd ..
    message "克隆仓库 \"$core_name\" 完成。"
    echo
    return 0
}

clone_mame2000() {
    common_clone_core "MAME 2000" "mame2000" "mame2000-libretro"
}

clone_mame2003_plus() {
    common_clone_core "MAME 2003 Plus" "mame2003_plus" "mame2003-plus-libretro"
}

clone_mame2010() {
    common_clone_core "MAME 2010" "mame2010" "mame2010-libretro"
}

clone_mame2015() {
    common_clone_core "MAME 2015" "mame2015" "mame2015-libretro"
}

clone_mame2016() {
    common_clone_core "MAME 2016" "mame2016" "mame2016-libretro"
}

clone_mame() {
    common_clone_core "MAME" "mame" "mame"
}

clone_fbalpha2012() {
    common_clone_core "Final Burn Alpha 2012" "fbalpha2012" "fbalpha2012"
}

clone_fbalpha2012_cps1() {
    common_clone_core "Final Burn Alpha 2012 CPS1" "fbalpha2012_cps1" "fbalpha2012_cps1"
}

clone_fbalpha2012_cps2() {
    common_clone_core "Final Burn Alpha 2012 CPS2" "fbalpha2012_cps2" "fbalpha2012_cps2"
}

clone_fbalpha2012_cps3() {
    common_clone_core "Final Burn Alpha 2012 CPS3" "fbalpha2012_cps3" "fbalpha2012_cps3"
}

clone_fbalpha2012_neogeo() {
    common_clone_core "Final Burn Alpha 2012 Neo Geo" "fbalpha2012_neogeo" "fbalpha2012_neogeo"
}

clone_fbneo() {
    common_clone_core "Final Burn Neo" "fbneo" "FBNeo"
}

clone_sameboy() {
    common_clone_core "SameBoy" "sameboy" "SameBoy"
}

clone_gearboy() {
    common_clone_core "Gearboy" "gearboy" "Gearboy"
}

clone_tgbdual() {
    common_clone_core "TGB Dual" "tgbdual" "tgbdual-librero"
}

clone_mgba() {
    common_clone_core "mGBA" "mgba" "mgba"
}

clone_fceumm() {
    common_clone_core "FCEUmm" "fceumm" "libretro-fceumm"
}

clone_nestopia() {
    common_clone_core "Nestopia" "nestopia" "nestopia"
}

clone_bsnes() {
    common_clone_core "bsnes" "bsnes" "bsnes-libretro"
}

clone_bsnes_mercury() {
    common_clone_core "bsnes mercury" "bsnes_mercury" "bsnes-mercury"
}

clone_bsnes2014() {
    common_clone_core "bsnes 2014" "bsnes2014" "bsnes2014" "libretro"
}

clone_bsnes_hd() {
    common_clone_core "bsnes HD" "bsnes_hd" "https://github.com/DerKoun/bsnes-hd"
}

clone_bsnes_jg() {
    common_clone_core "bsnes jg" "bsnes_jg" "bsnes_jg"
}

clone_snes9x() {
    common_clone_core "Snes9x" "snes9x" "snes9x"
}

clone_mupen64plus_next() {
    common_clone_core "Mupen64Plus-Next" "mupen64plus_next" "mupen64plus-libretro-nx"
}

clone_parallel_n64() {
    common_clone_core "ParaLLEl N64" "parallel_n64" "parallel-n64"
}

clone_dolphin() {
    common_clone_core "Dolphin" "dolphin" "dolphin"
}

clone_desmume() {
    common_clone_core "DeSmuME" "desmume" "desmume"
}

clone_melondsds() {
    common_clone_core "melonDS DS" "melondsds" "https://github.com/JesseTG/melonds-ds"
}

clone_citra() {
    common_clone_core "Citra" "citra" "citra"
}

clone_genesis_plus_gx() {
    common_clone_core "Genesis Plus GX" "genesis_plus_gx" "Genesis-Plus-GX"
}

clone_genesis_plus_gx_wide() {
    common_clone_core "Genesis Plus GX Wide" "genesis_plus_gx_wide" "Genesis-Plus-GX-Wide"
}

clone_picodrive() {
    common_clone_core "PicoDrive" "picodrive" "picodrive"
}

clone_mednafen_saturn() {
    common_clone_core "Beetle Saturn" "mednafen_saturn" "beetle-saturn-libretro"
}

clone_kronos() {
    common_clone_core "Kronos" "kronos" "yabause" "kronos"
}

clone_flycast() {
    common_clone_core "Flycast" "flycast" "https://github.com/flyinghead/flycast"
}

clone_mednafen_psx() {
    common_clone_core "Beetle PSX" "mednafen_psx" "beetle-psx-libretro"
}

clone_pcsx_rearmed() {
    common_clone_core "PCSX ReARMed" "pcsx_rearmed" "pcsx_rearmed"
}

clone_ppsspp() {
    common_clone_core "PPSSPP" "ppsspp" "https://github.com/hrydgard/ppsspp"
}

clone_mednafen_ngp() {
    common_clone_core "Beetle NeoPop" "mednafen_ngp" "beetle-ngp-libretro"
}

clone_neocd() {
    common_clone_core "NeoCD" "neocd" "neocd_libretro"
}

clone_opera() {
    common_clone_core "Opera" "opera" "opera-libretro"
}

clone_mednafen_pce() {
    common_clone_core "Beetle PCE" "mednafen_pce" "beetle-pce-libretro"
}

clone_mednafen_pce_fast() {
    common_clone_core "Beetle PCE Fast" "mednafen_pce_fast" "beetle-pce-fast-libretro"
}

clone_fmsx() {
    common_clone_core "fMSX" "fmsx" "fmsx-libretro"
}

clone_px68k() {
    common_clone_core "PX68k" "px68k" "px68k-libretro"
}

clone_dosbox_core() {
    common_clone_core "DOSBox Core" "dosbox_core" "dosbox-core" "libretro"
}

clone_dosbox_pure() {
    common_clone_core "DOSBox Pure" "dosbox_pure" "https://github.com/schellingb/dosbox-pure" "main"
}

clone_81() {
   common_clone_core "ZX81" "81" "81-libretro"
}

clone_fuse() {
   common_clone_core "Fuse" "fuse" "fuse-libretro"
}

clone_atari800() {
    common_clone_core "Atari800" "atari800" "libretro-atari800"
}

clone_stella() {
   common_clone_core "Stella" "stella" "https://github.com/stella-emu/stella"
}

clone_prosystem() {
    common_clone_core "ProSystem" "prosystem" "prosystem-libretro"
}

clone_virtualjaguar() {
    common_clone_core "Virtual Jaguar" "virtualjaguar" "virtualjaguar-libretro"
}

clone_mednafen_lynx() {
    common_clone_core "Beetle Lynx" "mednafen_lynx" "beetle-lynx-libretro"
}

clone_handy() {
    common_clone_core "Handy" "handy" "libretro-handy"
}

clone_holani() {
    common_clone_core "Holani" "holani" "https://github.com/LLeny/holani-retro"
}

clone_hatari() {
    common_clone_core "Hatari" "hatari" "hatari"
}

clone_bk() {
    common_clone_core "bk" "bk" "bk-emulator"
}

clone_blastem() {
    common_clone_core "BlastEm" "blastem" "blastem"
}

clone_bluemsx() {
    common_clone_core "blueMSX" "bluemsx" "blueMSX-libretro"
}

clone_cap32() {
    common_clone_core "Caprice32" "cap32" "libretro-cap32"
}

clone_crocods() {
    common_clone_core "CrocoDS" "crocods" "libretro-crocods"
}

clone_jaxe() {
    common_clone_core "JAXE" "jaxe" "https://github.com/kurtjd/jaxe" "main"
}

clone_ep128emu_core() {
    common_clone_core "ep128emu" "ep128emu_core" "ep128emu-core" "core"
}

clone_freeintv() {
    common_clone_core "FreeIntv" "freeintv" "FreeIntv"
}

clone_gambatte() {
    common_clone_core "Gambatte" "gambatte" "gambatte-libretro"
}

clone_gearcoleco() {
    common_clone_core "GearColeco" "gearcoleco" "https://github.com/drhelius/Gearcoleco"
}

clone_gearsystem() {
    common_clone_core "Gearsystem" "gearsystem" "https://github.com/drhelius/Gearsystem"
}

clone_gpsp() {
    common_clone_core "gpSP" "gpsp" "gpsp"
}

clone_gw() {
    common_clone_core "GW" "gw" "gw-libretro"
}

clone_hbmame() {
    common_clone_core "HBMAME" "hbmame" "hbmame-libretro"
}

clone_mednafen_gba() {
    common_clone_core "Beetle GBA" "mednafen_gba" "beetle-gba-libretro"
}

clone_mednafen_wswan() {
    common_clone_core "Beetle Cygne" "mednafen_wswan" "beetle-wswan-libretro"
}

clone_mednafen_pcfx() {
    common_clone_core "Beetle PC-FX" "mednafen_pcfx" "beetle-pcfx-libretro"
}

clone_mednafen_supergrafx() {
    common_clone_core "Beetle SuperGrafx" "mednafen_supergrafx" "beetle-supergrafx-libretro"
}

clone_mednafen_vb() {
    common_clone_core "Beetle VB" "mednafen_vb" "beetle-vb-libretro"
}

clone_meteor() {
    common_clone_core "Meteor" "meteor" "meteor-libretro"
}

clone_np2kai() {
    common_clone_core "Neko Project II Kai" "np2kai" "NP2kai"
}

clone_numero() {
    common_clone_core "Numero" "numero" "https://github.com/nbarkhina/numero"
}

clone_o2em() {
    common_clone_core "O2EM" "o2em" "libretro-o2em"
}

clone_oberon() {
    common_clone_core "Oberon" "oberon" "oberon-risc-emu"
}

clone_pcsx2() {
    common_clone_core "PCSX2" "pcsx2" "LRPS2"
}

clone_play() {
    common_clone_core "Play!" "play" "https://github.com/jpd002/Play-"
}

clone_pokemini() {
    common_clone_core "PokeMini" "pokemini" "PokeMini"
}

clone_potator() {
    common_clone_core "Potator" "potator" "potator"
}

clone_vice() {
    common_clone_core "VICE" "vice" "vice-libretro"
}

clone_puae() {
    common_clone_core "PUAE" "puae" "libretro-uae"
}

clone_quasi88() {
    common_clone_core "QUASI88" "quasi88" "quasi88-libretro"
}

clone_quicknes() {
    common_clone_core "QuickNES" "quicknes" "QuickNES_Core"
}

clone_race() {
    common_clone_core "RACE" "race" "RACE"
}

clone_same_cdi() {
    common_clone_core "SAME_CDI" "same_cdi" "same_cdi"
}

clone_sameduck() {
    common_clone_core "SameDuck" "sameduck" "sameduck" "SameDuck-libretro"
}

clone_scummvm() {
    common_clone_core "ScummVM" "scummvm" "scummvm"
}

clone_smsplus() {
    common_clone_core "SMS Plus GX" "smsplus" "smsplus-gx"
}

clone_squirreljme() {
    common_clone_core "SquirrelJME" "squirreljme" "https://github.com/SquirrelJME/SquirrelJME" "trunk"
}

clone_swanstation() {
    common_clone_core "SwanStation" "swanstation" "swanstation"
}

clone_theodore() {
    common_clone_core "Theodore" "theodore" "https://github.com/Zlika/theodore"
}

clone_tic80() {
    common_clone_core "TIC-80" "tic80" "https://github.com/nesbox/TIC-80" "main"
}

clone_uw8() {
    common_clone_core "MicroW8" "uw8" "uw8-libretro" "main"
}

clone_uzem() {
    common_clone_core "Uzem" "uzem" "libretro-uzem"
}

clone_vbam() {
    common_clone_core "VBA-M" "vbam" "https://github.com/visualboyadvance-m/visualboyadvance-m"
}

clone_vba_next() {
    common_clone_core "VBA Next" "vba_next" "vba-next"
}

clone_vecx() {
    common_clone_core "vecx" "vecx" "libretro-vecx"
}

clone_x1() {
    common_clone_core "Sharp X1" "x1" "xmil-libretro"
}

if [ $# -lt 1 ]; then
    echo "需要指定内核名称！可用内核："
    # declare -F | grep -i "\-f clone_" | cut -d" " -f3
    declare -F | grep -i "\-f clone_" | cut -d" " -f3 | cut -d"_" -f2-
    echo
    echo "示例："
    echo "# 拉取指定内核："
    echo "./clone_cores.sh 内核名称1 内核名称2"
    echo "# 拉取所有内核："
    echo "./clone_cores.sh all"
    exit 1
fi

pushd $(dirname "$0") >/dev/null
cd ..
if [ ! -d cores ]; then
    mkdir cores &>/dev/null
fi
cores_dir="$PWD/cores"
cd cores

if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "all" ]; then
    for core in $(declare -F | grep -i "\-f clone_" | cut -d" " -f3 | cut -d"_" -f2-); do 
        cd "$cores_dir"
        if [ -d "libretro-$core" ]; then
            message "内核目录已存在，跳过：\"$1\""
            echo
        else
            clone_$core || die
        fi
    done
else
    while [ $# -gt 0 ]; do
        if function_exists "clone_$1"; then
            cd "$cores_dir"
            if [ -d "libretro-$1" ]; then
                message "内核目录已存在，跳过：\"$1\""
                echo
            else
                clone_$1 || die
            fi
        else
            die "参数错误，内核不存在：\"$1\""
            echo
        fi
        shift
    done
fi

popd &>/dev/null
message "All done."
exit 0



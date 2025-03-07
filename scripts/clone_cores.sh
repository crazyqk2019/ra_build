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

common_clone_core() {
    local core_name=$1
    local core=$2
    local core_upstream=$3
    message "克隆仓库 \"$core_name\" (https://github.com/crazyqk2019/libretro-$core)..."
    git clone --recursive https://github.com/crazyqk2019/libretro-$core || die "克隆仓库出错！"
    cd libretro-$core
    message "添加上游仓库 \"$core_name\" (https://github.com/libretro/$core_upstream)..."
    git remote add upstream https://github.com/libretro/$core_upstream || die "添加上游仓库出错！"
    git config --local user.name crazyqk2019
    git config --local user.email crazyq@gmail.com
    cd ..
    message "克隆仓库 \"$core_name\" 完成。"
    echo

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
    message "Cloning FinalBurn Neo..."
    git clone --recursive https://github.com/crazyqk2019/libretro-fbneo || die "Failed!"
    cd libretro-fbneo
    message "Adding upstream repository for FinalBurn Neo..."
    git remote add upstream https://github.com/libretro/FBNeo || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_sameboy() {
    message "Cloning SameBoy..."
    git clone --recursive https://github.com/crazyqk2019/libretro-sameboy.git || die "Failed!"
    cd libretro-sameboy
    message "Adding upstream repository for SameBoy..."
    git remote add upstream https://github.com/libretro/SameBoy.git || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_gearboy() {
    message "Cloning Gearboy..."
    git clone --recursive https://github.com/crazyqk2019/libretro-gearboy.git || die "Failed!"
    cd libretro-gearboy
    message "Adding upstream repository for Gearboy..."
    git remote add upstream https://github.com/libretro/Gearboy.git || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_tgbdual() {
    message "Cloning TGB Dual..."
    git clone --recursive https://github.com/crazyqk2019/libretro-tgbdual.git || die "Failed!"
    cd libretro-tgbdual
    message "Adding upstream repository for TGB Dual..."
    git remote add upstream https://github.com/libretro/tgbdual-libretro.git || die "Failed!"
    cd ..
    message "Done."
    echo
}



clone_mgba() {
    message "Cloning mGBA..."
    git clone --recursive https://github.com/crazyqk2019/libretro-mgba || die "Failed!"
    cd libretro-mgba
    message "Adding upstream repository for mGBA..."
    git remote add upstream https://github.com/libretro/mgba || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_fceumm() {
    message "Cloning FCEUmm..."
    git clone --recursive https://github.com/crazyqk2019/libretro-fceumm || die "Failed!"
    cd libretro-fceumm
    message "Adding upstream repository for FCEUmm..."
    git remote add upstream https://github.com/libretro/libretro-fceumm || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_nestopia() {
    message "Cloning Nestopia UE..."
    git clone --recursive https://github.com/crazyqk2019/libretro-nestopia || die "Failed!"
    cd libretro-nestopia
    message "Adding upstream repository for Nestopia UE..."
    git remote add upstream https://github.com/libretro/nestopia || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_bsnes-mercury() {
    message "Cloning bsnes-mercury Accuracy..."
    git clone --recursive https://github.com/crazyqk2019/libretro-bsnes_mercury || die "Failed!"
    cd libretro-bsnes_mercury
    message "Adding upstream repository for bsnes-mercury Accuracy..."
    git remote add upstream https://github.com/libretro/bsnes-mercury || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_snes9x() {
    message "Cloning Snes9x..."
    git clone --recursive https://github.com/crazyqk2019/libretro-snes9x || die "Failed!"
    cd libretro-snes9x
    message "Adding upstream repository for Snes9x..."
    git remote add upstream https://github.com/libretro/snes9x || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_mupen64plus_next() {
    message "Cloning mupen64plus next..."
    git clone --recursive https://github.com/crazyqk2019/libretro-mupen64plus_next || die "Failed!"
    cd libretro-mupen64plus_next
    message "Adding upstream repository for Mupen64Plus..."
    git remote add upstream https://github.com/libretro/mupen64plus-libretro-nx || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_parallel_n64() {
    message "Cloning ParaLLEl N64..."
    git clone --recursive https://github.com/crazyqk2019/libretro-parallel_n64 || die "Failed!"
    cd libretro-parallel_n64
    message "Adding upstream repository for ParaLLEl N64..."
    git remote add upstream https://github.com/libretro/parallel-n64 || die "Failed!"
    cd ..
    message "Done."
    echo
}    

clone_genesis_plus_gx() {
    message "Cloning Genesis Plus GX..."
    git clone --recursive https://github.com/crazyqk2019/libretro-genesis_plus_gx || die "Failed!"
    cd libretro-genesis_plus_gx
    message "Adding upstream repository for Genesis Plus GX..."
    git remote add upstream https://github.com/libretro/Genesis-Plus-GX || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_picodrive() {
    message "Cloning PicoDrive..."
    git clone --recursive https://github.com/crazyqk2019/libretro-picodrive || die "Failed!"
    cd libretro-picodrive
    message "Adding upstream repository for PicoDrive..."
    git remote add upstream https://github.com/libretro/picodrive || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_mednafen_saturn() {
    message "Cloning Beetle Saturn..."
    git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_saturn || die "Failed!"
    cd libretro-mednafen_saturn
    message "Adding upstream repository for Beetle Saturn..."
    git remote add upstream https://github.com/libretro/beetle-saturn-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_yabause() {
    message "Cloning Yabause..."
    git clone --recursive https://github.com/crazyqk2019/libretro-yabause || die "Failed!"
    cd libretro-yabause
    message "Adding upstream repository for Yabause..."
    git remote add upstream https://github.com/libretro/yabause || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_flycast() {
    message "Cloning flycast..."
    git clone --recursive https://github.com/crazyqk2019/libretro-flycast || die "Failed!"
    cd libretro-flycast
    message "Adding upstream repository for flycast..."
    git remote add upstream https://github.com/libretro/flycast || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_beetle_psx() {
    message "Cloning Beetle PSX HW.."
    git clone --recursive https://github.com/crazyqk2019/libretro-beetle_psx || die "Failed!"
    cd libretro-beetle_psx
    message "Adding upstream repository for Beetle PSX HW..."
    git remote add upstream https://github.com/libretro/beetle-psx-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_pcsx_rearmed() {
    message "Cloning PCSX ReARMed..."
    git clone --recursive https://github.com/crazyqk2019/libretro-pcsx_rearmed || die "Failed!"
    cd libretro-pcsx_rearmed
    message "Adding upstream repository for PCSX ReARMed..."
    git remote add upstream https://github.com/libretro/pcsx_rearmed || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_ppsspp() {
    message "Cloning PPSSPP..."
    git clone --recursive https://github.com/crazyqk2019/libretro-ppsspp || die "Failed!"
    cd libretro-ppsspp
    message "Adding upstream repository for PPSSPP..."
    git remote add upstream https://github.com/libretro/ppsspp || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_mednafen_ngp() {
    message "Cloning Beetle NeoPop..."
    git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_ngp || die "Failed!"
    cd libretro-mednafen_ngp
    message "Adding upstream repository for Beetle NeoPop..."
    git remote add upstream https://github.com/libretro/beetle-ngp-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_neocd() {
    message "Cloning NeoCD-Libretro..."
    git clone --recursive https://github.com/crazyqk2019/libretro-neocd || die "Failed!"
    cd libretro-neocd
    message "Adding upstream repository for NeoCD-Libretro..."
    git remote add upstream https://github.com/libretro/neocd_libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_opera() {
    message "Cloning 4DO/Opera..."
    git clone --recursive https://github.com/crazyqk2019/libretro-opera || die "Failed!"
    cd libretro-opera
    message "Adding upstream repository for 4DO/Opera..."
    git remote add upstream https://github.com/libretro/opera-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_mednafen_pce() {
    message "Cloning Beetle PCE..."
    git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_pce || die "Failed!"
    cd libretro-mednafen_pce
    message "Adding upstream repository for Beetle PCE..."
    git remote add upstream https://github.com/libretro/beetle-pce-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_fmsx() {
    message "Cloning fMSX..."
    git clone --recursive https://github.com/crazyqk2019/libretro-fmsx || die "Failed!"
    cd libretro-fmsx
    message "Adding upstream repository for fMSX..."
    git remote add upstream https://github.com/libretro/fmsx-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_px68k() {
    message "Cloning PX68k..."
    git clone --recursive https://github.com/crazyqk2019/libretro-px68k || die "Failed!"
    cd libretro-px68k
    message "Adding upstream repository for PX68k..."
    git remote add upstream https://github.com/libretro/px68k-libretro || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_dosbox_core() {
    message "Cloning DOSBox Core..."
    git clone --recursive https://github.com/crazyqk2019/libretro-dosbox_core || die "Failed!"
    cd libretro-dosbox_core
    message "Adding upstream repository for DOSBox Core..."
    git remote add upstream https://github.com/realnc/dosbox-core || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_dolphin() {
    message "Cloning Dolphin..."
    git clone --recursive https://github.com/crazyqk2019/libretro-dolphin.git || die "Failed!"
    cd libretro-dolphin
    message "Adding upstream repository for Dolphin..."
    git remote add upstream https://github.com/libretro/dolphin.git || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_citra() {
    message "Cloning Citra..."
    git clone --recursive https://github.com/crazyqk2019/libretro-citra.git || die "Failed!"
    cd libretro-citra
    message "Adding upstream repository for Citra..."
    git remote add upstream https://github.com/libretro/citra.git || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_desmume() {
    message "Cloning DeSmuME..."
    git clone --recursive https://github.com/crazyqk2019/libretro-desmume.git || die "Failed!"
    cd libretro-desmume
    message "Adding upstream repository for DeSmuME..."
    git remote add upstream https://github.com/libretro/desmume.git || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_melonds() {
    message "Cloning melonDS..."
    git clone --recursive https://github.com/crazyqk2019/libretro-melonds.git || die "Failed!"
    cd libretro-melonds
    message "Adding upstream repository for melonDS..."
    git remote add upstream https://github.com/libretro/melonDS.git || die "Failed!"
    cd ..
    message "Done."
    echo
}

clone_bsnes() {
    message "Cloning bsnes..."
    git clone --recursive https://github.com/crazyqk2019/libretro-bsnes.git || die "Failed!"
    cd libretro-bsnes
    message "Adding upstream repository for bsnes..."
    git remote add upstream https://github.com/libretro/bsnes.git || die "Failed!"
    cd ..
    message "Done."
    echo
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
if [ -d cores ]; then
    mkdir cores &>/dev/null
fi
cd cores

if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "all" ]; then
    for core in $(declare -F | grep -i "\-f clone_" | cut -d" " -f3 | cut -d"_" -f2-); do 
        if [ -d "libretro-$core" ]; then
            message "内核目录已存在，跳过：$1"
            echo
        else
            clone_$core || (popd &>/dev/null && exit 1)
        fi
    done
else
    while [ $# -gt 0 ]; do
        if function_exists "clone_$1"; then
            if [ -d "libretro-$1" ]; then
                message "内核目录已存在，跳过：$1"
                echo
            else
                clone_$1 || (popd &>/dev/null && exit 1)
            fi
        else
            die "参数错误，内核不存在：$1"
            echo
        fi
        shift
    done
fi

popd &>/dev/null
message "All done."
exit 0



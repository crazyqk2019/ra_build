#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

pushd . &>/dev/null

cd ../cores

###############################################################################
$SETCOLOR_GREEN && echo "Cloning MAME 2003-Plus..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mame2003_plus
cd libretro-mame2003_plus

$SETCOLOR_GREEN && echo "Adding upstream repository for MAME 2003-Plus..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mame2003-plus-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning MAME 2010..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mame2010
cd libretro-mame2010

$SETCOLOR_GREEN && echo "Adding upstream repository for MAME 2010..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mame2010-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning MAME 2015..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mame2015
cd libretro-mame2015

$SETCOLOR_GREEN && echo "Adding upstream repository for MAME 2015..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mame2015-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning MAME 2016..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mame2016
cd libretro-mame2016

$SETCOLOR_GREEN && echo "Adding upstream repository for MAME 2016..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mame2016-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning MAME..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mame
cd libretro-mame

$SETCOLOR_GREEN && echo "Adding upstream repository for MAME..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mame
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning FinalBurn Alpha 2012..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-fbalpha2012
cd libretro-fbalpha2012

$SETCOLOR_GREEN && echo "Adding upstream repository for FinalBurn Alpha 2012..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/fbalpha2012
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning FinalBurn Neo..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-fbneo
cd libretro-fbneo

$SETCOLOR_GREEN && echo "Adding upstream repository for FinalBurn Neo..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/FBNeo
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning mGBA..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mgba
cd libretro-mgba

$SETCOLOR_GREEN && echo "Adding upstream repository for mGBA..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mgba
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning FCEUmm..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-fceumm
cd libretro-fceumm

$SETCOLOR_GREEN && echo "Adding upstream repository for FCEUmm..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/libretro-fceumm
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Nestopia UE..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-nestopia
cd libretro-nestopia

$SETCOLOR_GREEN && echo "Adding upstream repository for Nestopia UE..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/nestopia
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning bsnes-mercury Accuracy..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-bsnes_mercury
cd libretro-bsnes_mercury

$SETCOLOR_GREEN && echo "Adding upstream repository for bsnes-mercury Accuracy..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/bsnes-mercury
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Snes9x..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-snes9x
cd libretro-snes9x

$SETCOLOR_GREEN && echo "Adding upstream repository for Snes9x..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/snes9x
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Mupen64Plus..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mupen64plus_next
cd libretro-mupen64plus_next

$SETCOLOR_GREEN && echo "Adding upstream repository for Mupen64Plus..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/mupen64plus-libretro-nx
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning ParaLLEl N64..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-parallel_n64
cd libretro-parallel_n64

$SETCOLOR_GREEN && echo "Adding upstream repository for ParaLLEl N64..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/parallel-n64
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Genesis Plus GX..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-genesis_plus_gx
cd libretro-genesis_plus_gx

$SETCOLOR_GREEN && echo "Adding upstream repository for Genesis Plus GX..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/Genesis-Plus-GX
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning PicoDrive..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-picodrive
cd libretro-picodrive

$SETCOLOR_GREEN && echo "Adding upstream repository for PicoDrive..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/picodrive
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Beetle Saturn..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_saturn
cd libretro-mednafen_saturn

$SETCOLOR_GREEN && echo "Adding upstream repository for Beetle Saturn..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/beetle-saturn-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Yabause..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-yabause
cd libretro-yabause

$SETCOLOR_GREEN && echo "Adding upstream repository for Yabause..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/yabause
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning flycast..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-flycast
cd libretro-flycast

$SETCOLOR_GREEN && echo "Adding upstream repository for flycast..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/flycast
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Beetle PSX HW.." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_psx_hw
cd libretro-mednafen_psx_hw

$SETCOLOR_GREEN && echo "Adding upstream repository for Beetle PSX HW..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/beetle-psx-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning PCSX ReARMed..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-pcsx_rearmed
cd libretro-pcsx_rearmed

$SETCOLOR_GREEN && echo "Adding upstream repository for PCSX ReARMed..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/pcsx_rearmed
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning PPSSPP..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-ppsspp
cd libretro-ppsspp

$SETCOLOR_GREEN && echo "Adding upstream repository for PPSSPP..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/ppsspp
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Beetle NeoPop..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_ngp
cd libretro-mednafen_ngp

$SETCOLOR_GREEN && echo "Adding upstream repository for Beetle NeoPop..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/beetle-ngp-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning NeoCD-Libretro..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-neocd
cd libretro-neocd

$SETCOLOR_GREEN && echo "Adding upstream repository for NeoCD-Libretro..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/neocd_libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning 4DO/Opera..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-opera
cd libretro-opera

$SETCOLOR_GREEN && echo "Adding upstream repository for 4DO/Opera..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/opera-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Beetle PCE..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-mednafen_pce
cd libretro-mednafen_pce

$SETCOLOR_GREEN && echo "Adding upstream repository for Beetle PCE..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/beetle-pce-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning fMSX..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-fmsx
cd libretro-fmsx

$SETCOLOR_GREEN && echo "Adding upstream repository for fMSX..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/fmsx-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning PX68k..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-px68k
cd libretro-px68k

$SETCOLOR_GREEN && echo "Adding upstream repository for PX68k..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/px68k-libretro
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning DOSBox Core..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-dosbox_core
cd libretro-dosbox_core

$SETCOLOR_GREEN && echo "Adding upstream repository for DOSBox Core..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/realnc/dosbox-core
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Dolphin..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-dolphin.git
cd libretro-dolphin

$SETCOLOR_GREEN && echo "Adding upstream repository for Dolphin..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/dolphin.git
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Citra..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-citra.git
cd libretro-citra

$SETCOLOR_GREEN && echo "Adding upstream repository for Citra..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/citra.git
cd ..

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################


###############################################################################
$SETCOLOR_GREEN && echo "Cloning DeSmuME..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-desmume.git
cd libretro-desmume
$SETCOLOR_GREEN && echo "Adding upstream repository for DeSmuME..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/desmume.git
cd ..
$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning melonDS..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-melonds.git
cd libretro-melonds
$SETCOLOR_GREEN && echo "Adding upstream repository for melonDS..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/melonDS.git
cd ..
$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning SameBoy..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-sameboy.git
cd libretro-sameboy
$SETCOLOR_GREEN && echo "Adding upstream repository for SameBoy..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/SameBoy.git
cd ..
$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning Gearboy..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-gearboy.git
cd libretro-gearboy
$SETCOLOR_GREEN && echo "Adding upstream repository for Gearboy..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/Gearboy.git
cd ..
$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning TGB Dual..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-tgbdual.git
cd libretro-tgbdual
$SETCOLOR_GREEN && echo "Adding upstream repository for TGB Dual..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/tgbdual-libretro.git
cd ..
$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################

###############################################################################
$SETCOLOR_GREEN && echo "Cloning bsnes..." && $SETCOLOR_NORMAL
git clone --recursive https://github.com/crazyqk2019/libretro-bsnes.git
cd libretro-bsnes
$SETCOLOR_GREEN && echo "Adding upstream repository for bsnes..." && $SETCOLOR_NORMAL
git remote add upstream https://github.com/libretro/bsnes.git
cd ..
$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL
###############################################################################


popd &>/dev/null
$SETCOLOR_GREEN && echo "All done." && $SETCOLOR_NORMAL

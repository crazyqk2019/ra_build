#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

./build_core_bsnes_mercury.sh
./build_core_fbalpha2012.sh
./build_core_fbneo.sh
./build_core_fceumm.sh
./build_core_flycast.sh
./build_core_fmsx.sh
./build_core_genesis_plus_gx.sh
./build_core_mednafen_ngp.sh
./build_core_mednafen_pce.sh
./build_core_mednafen_psx_hw.sh
./build_core_mednafen_saturn.sh
./build_core_mgba.sh
./build_core_mupen64plus_next.sh
./build_core_neocd.sh
./build_core_nestopia.sh
./build_core_opera.sh
./build_core_parallel_n64.sh
./build_core_pcsx_rearmed.sh
./build_core_picodrive.sh
./build_core_ppsspp.sh
./build_core_px68k.sh
./build_core_snes9x.sh
./build_core_yabause.sh
./build_core_mame2003_plus.sh
./build_core_mame2010.sh
./build_core_mame2015.sh
./build_core_mame2016.sh
./build_core_mame.sh
./build_core_dosbox_core.sh
./build_core_dolphin.sh
./build_core_citra.sh

$SETCOLOR_GREEN && echo "All done." && $SETCOLOR_NORMAL



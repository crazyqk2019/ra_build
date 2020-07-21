#!/bin/bash

SETCOLOR_GREEN="echo -en \\E[1;32m"
SETCOLOR_NORMAL="echo -en \\E[0;39m"

$SETCOLOR_GREEN && echo "Cloning RetroArch..." && $SETCOLOR_NORMAL
git clone https://github.com/libretro/RetroArch retroarch_orig

$SETCOLOR_GREEN && echo "Done." && $SETCOLOR_NORMAL

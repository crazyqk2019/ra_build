# Windows下RetroArch编译/汉化环境


## 目录说明
- pkgs -- 第三方lib库包
- retroarch_dist -- RetroArch编译输出目录
- retrorach_font -- RetroArch包含中文字体
- cores -- 内核source目录
- cores_dist -- 内核编译输出目录

## 文件说明
- inst_pkgs.sh -- 安装必需的msys和mingw包
- dist_retro.sh -- 提取RetorArch.exe依赖的dll库
- dist_retro_noqt.sh -- 提取RetorArch.exe依赖的dll库，不包括Qt
- dist_cores.sh -- 提取内核依赖的dll库
- build_core_cmds.txt 部分内核特殊编译命令

## msys2/mingw64编译环境安装步骤
1. 从 https://www.msys2.org/ 下载msys2安装器进行安装
2. 修改配置，以使用wget下载安装包
编辑 /etc/pacman.conf 去掉此行注释
`XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u`
3. 使用清华大学服务器镜像
编辑 /etc/pacman.d下的mirrorlist.*文件
把 https://mirrors.tuna.tsinghua.edu.cn 服务器地址移到最前面
4. 升级 msys2
运行 pacman -Syu 数次，直到无更新
5. 安装必要包
运行inst_pkgs.sh
6. 安装pkgs目录中的包，可直接解压安装，无须用pacman命令安装


## 个人汉化RA主程序
- [汉化仓库地址](https://github.com/crazyqk2019/RetroArch)
- [原始仓库地址](https://github.com/libretro/RetroArch)


## 个人汉化内核

- ### 街机模拟器
	* [MAME 2003-Plus](https://docs.libretro.com/library/mame2003_plus/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mame2003_plus)
		+ [原始仓库地址](https://github.com/libretro/mame2003-plus-libretro)
	* [MAME 2010](https://docs.libretro.com/library/mame_2010/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mame2010)
		+ [原始仓库地址](https://github.com/libretro/mame2010-libretro)
	* MAME 2015
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mame2015)
		+ [原始仓库地址](https://github.com/libretro/mame2015-libretro)
	* MAME 2016
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mame2016)
		+ [原始仓库地址](https://github.com/libretro/mame2016-libretro)
	* MAME
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mame)
		+ [原始仓库地址](https://github.com/libretro/mame)
	* FinalBurn Alpha 2012
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-fbalpha2012)
		+ [原始仓库地址](https://github.com/libretro/fbalpha2012)
	* FinalBurn Neo
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-fbneo)
		+ [原始仓库地址](https://github.com/libretro/FBNeo)
----
- ### Nintendo GBA模拟器
	* [mGBA](https://docs.libretro.com/library/mgba/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mgba)
		+ [原始仓库地址](https://github.com/libretro/mgba)

- ### Nintendo NES/FC模拟器
	* [FCEUmm](https://docs.libretro.com/library/fceumm/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-fceumm)
		+ [原始仓库地址](https://github.com/libretro/libretro-fceumm)
	* [Nestopia UE](https://docs.libretro.com/library/nestopia_ue/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-nestopia)
		+ [原始仓库地址](https://github.com/libretro/nestopia)
	
- ### Nintendo SNES/SFC模拟器
	* [bsnes-mercury Accuracy](https://docs.libretro.com/library/bsnes_mercury_accuracy/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-bsnes_mercury)
		+ [原始仓库地址](https://github.com/libretro/bsnes-mercury)
	* [Snes9x](https://docs.libretro.com/library/snes9x/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-snes9x)
		+ [原始仓库地址](https://github.com/libretro/snes9x)
	
- ### Nintendo 64模拟器
	* [Mupen64Plus](https://docs.libretro.com/library/mupen64plus/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mupen64plus_next)
		+ [原始仓库地址](https://github.com/libretro/mupen64plus-libretro-nx)
	* ParaLLEl N64
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-parallel_n64)
		+ [原始仓库地址](https://github.com/libretro/parallel-n64)
----
- ### Sega MS/GG/MD/CD模拟器
	* [Genesis Plus GX](https://docs.libretro.com/library/genesis_plus_gx/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-genesis_plus_gx)
		+ [原始仓库地址](https://github.com/libretro/Genesis-Plus-GX)
	
- ### # Sega MS/MD/CD/32X模拟器
	* [PicoDrive](https://docs.libretro.com/library/picodrive/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-picodrive)
		+ [原始仓库地址](https://github.com/libretro/picodrive)

- ### Sega 土星模拟器
	* [Beetle Saturn](https://docs.libretro.com/library/beetle_saturn/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mednafen_saturn)
		+ [原始仓库地址](https://github.com/libretro/beetle-saturn-libretro)
	* [Yabause](https://docs.libretro.com/library/yabause/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-yabause)
		+ [原始仓库地址](https://github.com/libretro/yabause)
  
- ### Sega Dreamcast / NAOMI / Atomiswave模拟器
	* [flycast](https://docs.libretro.com/library/flycast/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-flycast)
		+ [原始仓库地址](https://github.com/libretro/flycast)
----
- ### Sony PlayStation模拟器
	* [Beetle PSX HW](https://docs.libretro.com/library/beetle_psx_hw/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mednafen_psx_hw)
		+ [原始仓库地址](https://github.com/libretro/beetle-psx-libretro)
	* [PCSX ReARMed](https://docs.libretro.com/library/pcsx_rearmed/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-pcsx_rearmed)
		+ [原始仓库地址](https://github.com/libretro/pcsx_rearmed)

- ### Sony PlayStation Portable模拟器
	* [PPSSPP](https://docs.libretro.com/library/ppsspp/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-ppsspp)
		+ [原始仓库地址](https://github.com/libretro/ppsspp)
----
- ### SNK Neo Geo Pocket / Color模拟器
	* [Beetle NeoPop](https://docs.libretro.com/library/beetle_neopop/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mednafen_ngp)
		+ [原始仓库地址](https://github.com/libretro/beetle-ngp-libretro)

- ### SNK NeoCD模拟器
	* NeoCD-Libretro
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-neocd)
		+ [原始仓库地址](https://github.com/libretro/neocd_libretro)
----
- ### The 3DO Company 3DO模拟器
	* [4DO/Opera](https://docs.libretro.com/library/4do/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-opera)
		+ [原始仓库地址](https://github.com/libretro/opera-libretro)
----
- ### NEC PC-Engine模拟器
	* Beetle PCE
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-mednafen_pce)
		+ [原始仓库地址](https://github.com/libretro/beetle-pce-libretro)
----
- ### Microsoft MSX模拟器
	* [fMSX](https://docs.libretro.com/library/fmsx/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-fmsx)
		+ [原始仓库地址](https://github.com/libretro/fmsx-libretro)
----
- ### Sharp X68000模拟器
	* [PX68k](https://docs.libretro.com/library/px68k/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-px68k)
		+ [原始仓库地址](https://github.com/libretro/px68k-libretro)
----
- ### DOS模拟器
	* [DOSBox Core](https://docs.libretro.com/library/dosbox/)
		+ [汉化仓库地址](https://github.com/crazyqk2019/libretro-dosbox_core)
		+ [原始仓库地址](https://github.com/realnc/dosbox-core)

## 特殊内核编译方法

### libretro-parallel_n64
编译命令：

```bash
make HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64
```

### libretro-mednafen_psx_hw

编译命令：

```bash
make HAVE_HW=1
```

### libretro-bsnes_mercury

三个不同的profile编译命令
```bash
make profile=accuracy
make profile=balanced
make profile=performance
```

### libretro-dosbox_core

编译命令：
```bash
make BUNDLED_AUDIO_CODECS=0 BUNDLED_LIBSNDFILE=0 WITH_DYNAREC=x86_64
```
拷贝依赖的dll：
```bash
cd cores_dist
../dist_cores.sh dosbox_core_libretro.dll
```

### libretro-ppsspp

只能用VC2019编译，mingw编译通不过。

必要软件和编译步骤：

1. 安装 VC2019 Community

2. 通过 Windows  Store 安装 Python

3. 生成 `.vcproject` 文件

   ```bash
	mkdir build
	cd build
	cmake -DLIBRETRO=ON -DCMAKE_CXX_FLAGS_RELEASE="/MT /UTF-8" ..
	```
	
5. 编译
	```bash
	cd libretro
	msbuild ppsspp_libretro.vcxproj -p:Platform=x64;Configuration=Release
	```
	
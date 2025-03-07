# Windows下RetroArch编译/汉化环境

## MSYS2/MinGW64编译环境安装步骤

1. 安装[Git for Windows](https://gitforwindows.org/)或者[TortoiseGit](https://tortoisegit.org/)，把路径加入PATH环境变量。

2. 从 https://www.msys2.org/ 下载msys2安装器进行安装

3. （可选）修改配置（之前版本msys2使用curl下载有bug），以使用wget下载安装包
     编辑 /etc/pacman.conf 去掉此行注释：

     ```bash
     XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
     ```

4. （可选）使用清华大学服务器镜像
     编辑 /etc/pacman.d下的mirrorlist.*文件
       把 https://mirrors.tuna.tsinghua.edu.cn 服务器地址移到最前面

5. 进入msys2 shell环境。

6. 升级msys2：运行 `pacman -Syu` 数次，直到无更新

7. 运行`scripts/inst_pkgs.sh`脚本，安装编译所需工具和依赖包。(默认使用ucrt64工具链)

8. ~~安装pkgs目录中的包，直接解压到对应目录，无须用pacman命令安装~~（这些包已经可以在第6步使用pacman直接下载）

> [!TIP]
>
> 命令行下使用 `msys2_shell.cmd -msys2 -defterm -no-start`命令可以在不打开新窗口的情况下，在当前终端进入msys环境。运行 `msys2_shell.cmd --help`可查看帮助。

## 拉取RA源代码

1. 进入ucrt64环境，执行：

   ```bash
   git clone https://github.com/libretro/RetroArch retroarch
   ```

2. ~~完成后进入retroarch源代码目录，执行拉取子模块脚本：~~（子模块为资源，可以直接在<https://buildbot.libretro.com/assets/frontend/>下载打包好的资源）

   ```bash
   ./fetch-submodules.sh
   ```

> [!NOTE]
>
> 可使用`scripts/clone_ra_orig.sh`和`scripts/clone_ra.sh`脚本自动执行拉取。

## 编译RA主程序



1. 进入ucrt64编译环境：

   ```cmd
   `msys2_shell.cmd -ucrt64 -defterm -no-start`
   ```

2. 进入RA源代码目录，运行配置程序：

   ```bash
   ./configure
   ```

3. 编译：

   ```bash
   make clean
   make -j
   ```

4. 裁剪优化，减小可执行文件大小：

   ```bash
   strip -s retroarch.exe
   ```

> [!NOTE]
>
> 可使用`scripts/build_ra.sh`脚本自动执行以上编译步骤（在源代码根目录下运行）。

## 编译视频滤镜和音频滤镜(DSP)

1. 编译视频滤镜：

   ```bash
   cd gfx/video_filters
   make -j
   ```

2. 编译音频滤镜(DSP)

   ```bash
   cd libretro-common/audio/dsp_filters
   make -j
   ```

> [!NOTE]
>
> 可使用`scripts/build_ra_filters.sh`脚本自动编译视频滤镜和音频DSP（在源代码根目录下运行）。

## 建立完整RA发行目录

1. 拷贝retroarch.exe到分发目录。

2. 拷贝依赖的msys和mingw的dll:

   ```bash
   for bin in $(ntldd -R retroarch.exe | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$bin" . ; done;
   ```

3. 拷贝依赖的QT的dll:

   ```bash
   windeployqt6 retroarch.exe
   for bin in $(ntldd -R imageformats/*dll | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2); do cp -v "$bin" . ; done;
   ```

4. 拷贝音视频滤镜：

   ```bash
   mkdir -p ../retroarch_dist/filters/video
   cp -t ../retroarch_dist/filters/video gfx/video_filters/*.dll gfx/video_filters/*.filt
   mkdir -p ../retroarch_dist/filters/audio
   cp -t ../retroarch_dist/filters/audio libretro-common/audio/dsp_filters/*.dll libretro-common/audio/dsp_filters/*.dsp
   ```

5. 从<https://buildbot.libretro.com/assets/frontend/>下载并解压其他资源:

   ```bash
   wget https://buildbot.libretro.com/assets/frontend/assets.zip
   7z x assets.zip -oassets
   rm assets.zip
   
   wget https://buildbot.libretro.com/assets/frontend/autoconfig.zip
   7z x autoconfig.zip -oautoconfig
   rm autoconfig.zip
   
   wget https://buildbot.libretro.com/assets/frontend/cheats.zip
   7z x cheats.zip -ocheats
   rm cheats.zip
   
   wget https://buildbot.libretro.com/assets/frontend/database-cursors.zip
   7z x database-cursors.zip -odatabase/cursors
   rm database-cursors.zip
   
   7z x database-rdb.zip -odatabase/rdb
   rm database-rdb.zip
   
   wget https://buildbot.libretro.com/assets/frontend/info.zip
   7z x info.zip -oinfo
   rm info.zip
   
   wget https://buildbot.libretro.com/assets/frontend/overlays.zip
   7z x overlays.zip -ooverlays
   rm overlays.zip
   
   wget https://buildbot.libretro.com/assets/frontend/shaders_cg.zip
   7z x shaders_cg.zip -oshaders/shaders_cg
   rm shaders_cg.zip
   
   wget https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip
   7z x shaders_glsl.zip -oshaders/shaders_glsl
   rm shaders_glsl.zip
   
   wget https://buildbot.libretro.com/assets/frontend/shaders_slang.zip
   7z x shaders_slang.zip -oshaders/shaders_slang
   rm shaders_slang.zip
   ```

> [!NOTE]
>
> 可使用`scripts\dist_ra.sh`脚本自动执行以上步骤（在源代码根目录下运行）。

## 中文显示问题

目前RA的assets资源里自带一个中文字体`chinese-fallback-font.ttf`（在assets/pkg目录下），但是该字体仍然不完善，会有显示方块的问题。

建议使用[Maple Mono](chinese-fallback-font.ttf)字体。

- 低分辨屏（1080p及以下）建议使用`MapleMonoNL-CN-unhinted`（不含控制台图形字符、无连字、含中文、有渲染提示）
- 高分辨率屏（1080p以上）建议使用`MapleMonoNL-CN`（不含控制台图形字符、无连字、含中文、无渲染提示）

根据选择把下载好的字体regular版本更名为`chinese-fallback-font.ttf`，覆盖assets/pkg目录下同名文件。

## 模拟器内核编译方法

### 通用内核编译方法

进入内核源代码目录，如果存在Makefile.libretro文件，运行：

```bash
make -f Makefile.libretro
```

如果不存在Makefile.libretro文件，直接运行：

```bash
make
```

裁剪，去除调试信息：

```bash
strip -s libretro-*.dll
```

### 需要特殊处理的内核编译

#### MAME 2015

需要在make命令行添加"CC=g++"参数，指定使用g++编译，否则链接时会出错，找不到c++的部分库。

```bash
make CC=g++
```

#### MAME 2016

需要在make命令行指定编译环境ucrt64根目录，指定使用python3。

```bash
make MINGW64=/ucrt64 PYTHON_EXECUTABLE=python3
```

#### MAME

需要在make命令行指定编译环境ucrt64根目录，指定使用python3。

```bash
make MINGW64=/ucrt64 PYTHON_EXECUTABLE=python3
```

需要用MSVC编译的内核需要安装VC,CMake和Python：

1. 下载安装 [VC2019 Community](https://visualstudio.microsoft.com/zh-hans/vs/)
    安装后会包含CMake
2. 通过 Windows  Store 安装 Python3

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

### libretro-bsnes
```bash
cd bsnes
make -f GNUmakefile target=libretro binary=library
```

### libretro-bsnes_mercury
三个不同的profile编译命令，默认编译accurary。
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
需用VC2019编译。
1. 生成 `.vcproject` 文件，进入VC2019 x64命令行，运行：
```shell
mkdir build
cd build
cmake -G "Visual Studio 16 2019" -DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/MT /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MT /utf-8" ..
```
2. 编译
```shell
cd libretro
msbuild ppsspp_libretro.vcxproj -p:Platform=x64;Configuration=Release
```

### libretro-dolphin
需用VC2019编译。
1. 生成 `.vcproject` 文件，进入VC2019 x64命令行，运行：
```shell
mkdir build
cd build
cmake -G "Visual Studio 16 2019" -DLIBRETRO=ON -DCMAKE_C_FLAGS="/utf-8 /D_SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING" -DCMAKE_CXX_FLAGS="/utf-8 /D_SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING" ..
```
2. 编译
```shell
cd Source\Core\DolphinLibretro
msbuild dolphin_libretro.vcxproj -p:Platform=x64;Configuration=Release
```

### libretro-citra
可以使用VC2019或者MSYS2编译，默认使用VC编译。
- VC2019编译步骤：
1. 生成`.vcproject`文件
```shell
mkdir build
cd build
cmake -G "Visual Studio 16 2019" -DENABLE_LIBRETRO=ON -DENABLE_QT=OFF -DENABLE_SDL2=OFF -DENABLE_WEB_SERVICE=OFF ..
```
2. 编译
```shell
cd src\citra_libretro
msbuild citra_libretro.vcxproj -p:Platform=x64;Configuration=Release
```

- MSYS2编译步骤：
1. 生成Makefile
```shell
mkdir build
cd build
cmake -G "MSYS Makefiles" -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCMAKE_BUILD_TYPE="Release" .. 
```

2. 编译
```shell
cd src/citra_libretro
make -j`nproc`
```

## 目录说明

- scripts -- 安装/拉取/编译脚本
- tools -- 需要用的一些第三方工具

## scripts目录下脚本文件说明

| 文件名              | 用途                                                         |
| ------------------- | ------------------------------------------------------------ |
| msys2shell.cmd      | 进入msys2 shell环境，运行方法为：`msys2shell.cmd <msys2安装目录>` |
| ucrt64shell.cmd     | 进入ucrt64 shell环境，运行方法为：`ucrt64shell.cmd <msys2安装目录>` |
| inst_pkgs.sh        | 安装编译所需的软件、编译工具链和依赖库。                     |
| clone_ra_orig.sh    | 克隆原始RetroArch源代码到retroarch_orig目录。                |
| clone_ra.sh         | 克隆RetroArch汉化库源代码到retrorch目录，并把原始RA仓库添加为上游仓库。 |
| build_ra.sh         | 编译RetroArch，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| build_ra_filters.sh | 编译音视频滤镜，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| dist_ra.sh          | 创建RetroArch分发目录retroarch_dist，请在retroarch_orig或者retrorch源代码根目录下运行。 |
|                     |                                                              |
|                     |                                                              |

- clone_all_cores.sh -- 拉取所有内核源代码
- build_core_xxx.sh -- 编译各个内核
- build_all_cores.sh -- 编译所有内核
- dist_core.sh -- 提取内核依赖的dll库
- vc_build_ppsspp.bat -- 调用VC2019编译PPSSPP的特殊命令，由build_core_ppsspp.sh调用
- vc_build_citra.bat -- 调用VC2019编译Citra的特殊命令，由build_core_citra.sh调用
- vc_build_dolphin.bat -- 调用VC2019编译Dolphin的特殊命令，由build_core_dolphin.sh调用

## 个人汉化内核列表

### 街机模拟器

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 最新汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------ |
| MAME 2000                                                    | [libretro-mame2000](https://github.com/crazyqk2019/libretro-mame2000) | 2000 version of MAME (0.37b5) for libretro. Compatible with iMAME4All/MAME4Droid/MAME 0.37b5 |                    |
| [MAME 2003-Plus](https://docs.libretro.com/library/mame2003_plus/) | [libretro-mame2003_plus](https://github.com/crazyqk2019/libretro-mame2003_plus) | Updated 2018 version of MAME (0.78) for libretro.            |                    |
| [MAME 2010](https://docs.libretro.com/library/mame_2010/)    | [libretro-mame2010](https://github.com/crazyqk2019/libretro-mame2010) | Late 2010 version of MAME (0.139) for libretro.              |                    |
| MAME 2015                                                    | [libretro-mame2015](https://github.com/crazyqk2019/libretro-mame2015) | Late 2014/Early 2015 version of MAME (0.160-ish) for libretro. |                    |
| MAME 2016                                                    | [libretro-mame2016](https://github.com/crazyqk2019/libretro-mame2016) | Late 2016 version of MAME (0.174) for libretro.              |                    |
| MAME                                                         | [libretro-mame](https://github.com/crazyqk2019/libretro-mame) | MAME - Multiple Arcade Machine Emulator                      |                    |
| Final Burn Alpha 2012                                        | [libretro-fbalpha2012](https://github.com/crazyqk2019/libretro-fbalpha2012) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). |                    |
| Final Burn Alpha 2012 CPS1                                   | [libretro-fbalpha2012_cps1](https://github.com/crazyqk2019/libretro-fbalpha2012_cps1) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Capcom CPS1. |                    |
| Final Burn Alpha 2012 CPS2                                   | [libretro-fbalpha2012_cps2](https://github.com/crazyqk2019/libretro-fbalpha2012_cps2) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Capcom CPS2. |                    |
| Final Burn Alpha 2012 CPS3                                   | [libretro-fbalpha2012_cps3](https://github.com/crazyqk2019/libretro-fbalpha2012_cps3) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Capcom CPS3. |                    |
| Final Burn Alpha 2012 Neo Geo                                | [libretro-fbalpha2012_neogeo](https://github.com/crazyqk2019/libretro-fbalpha2012_neogeo) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Neo Geo. |                    |
| [FinalBurn Neo](https://docs.libretro.com/library/fbneo/)    | [libretro-fbneo](https://github.com/crazyqk2019/libretro-fbneo) | FBNeo is the follow-up of the FinalBurn and FinalBurn Alpha emulators. |                    |

----
### Nintendo GB/GBC/GBA模拟器

| 内核名称 | 汉化仓库地址                                                 | 内核说明                                                     | 最新汉化时间和版本 |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------ |
| SameBoy  | [libretro-sameboy](https://github.com/crazyqk2019/libretro-sameboy) | Gameboy and Gameboy Color emulator written in C              |                    |
| Gearboy  | [libretro-gearboy](https://github.com/crazyqk2019/libretro-gearboy) | Game Boy / Gameboy Color emulator for iOS, Mac, Raspberry Pi, Windows, Linux and RetroArch |                    |
| TGB Dual | [libretro-tgbdual](https://github.com/crazyqk2019/libretro-tgbdual) | libretro port of TGB Dual                                    |                    |
| mGBA     | [libretro-mgba](https://github.com/crazyqk2019/libretro-mgba) | mGBA Game Boy Advance Emulator                               |                    |



- ### Nintendo NES/FC模拟器
    * [FCEUmm](https://docs.libretro.com/library/fceumm/)
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-fceumm)
        + [原始仓库地址](https://github.com/libretro/libretro-fceumm)
    * [Nestopia UE](https://docs.libretro.com/library/nestopia_ue/)
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-nestopia)
        + [原始仓库地址](https://github.com/libretro/nestopia)

- ### Nintendo SNES/SFC模拟器
    * bsnes
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-bsnes)
        + [原始仓库地址](https://github.com/libretro/bsnes)
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

- ### Nintendo Gamecube/Wii模拟器
    * [Dolphin](https://docs.libretro.com/library/dolphin/)
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-dolphin)
        + [原始仓库地址](https://github.com/libretro/dolphin)

- ### Nintendo - DS模拟器
    * [DeSmuME](https://docs.libretro.com/library/desmume/)
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-desmume)
        + [原始仓库地址](https://github.com/libretro/desmume)
    * [melonDS](https://docs.libretro.com/library/melonds/)
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-melonds)
        + [原始仓库地址](https://github.com/libretro/melonDS)

- ### Nintendo 3DS模拟器
    * [Citra](https://docs.libretro.com/library/citra/)
        + [汉化仓库地址](https://github.com/crazyqk2019/libretro-citra)
        + [原始仓库地址](https://github.com/libretro/citra)

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
    * [PPSSPP](https://docs.libretro.com/library/ppsspp/)(同步到v1.9.4)
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

## 如何同步上游仓库更新

1. 添加上游仓库：

   ```bash
   git remote add upstream https://github.com/原始仓库地址.git
   ```

2. 拉取上游仓库最新代码。

   ```bash
   git fetch upstream
   ```

3. 合并到本地分支，假设同步分支master分支。

   ```bash
   git merge upstream/master
   ```

4. 处理合并冲突，可借助图形化工具。

5. 提交，可借助图形化工具。

## 如何处理git换行符问题

```bash
# 拉取和提交时都保持原样，不要自动转换换行符
git config --system core.autocrlf false
git config --global core.autocrlf false
# 提交时检查换行符，不许提交包含混合换行符的文件
git config --system core.safecrlf true
git config --global core.safecrlf true
```



---

[官方Windows编译指导]: https://docs.libretro.com/development/retroarch/compilation/windows/
[官方最新编译和资源下载]: https://buildbot.libretro.com/




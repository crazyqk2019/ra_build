# Windows下RetroArch编译/汉化环境

## MSYS2/MinGW64编译环境安装

1. 安装[Git for Windows](https://gitforwindows.org/)和[TortoiseGit](https://tortoisegit.org/)，把路径加入PATH环境变量。

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

## 如何完整编译和分发RA

###  1. 拉取RA源代码

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

### 2. 编译RA主程序

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

### 3. 编译RA视频滤镜和音频滤镜(DSP)

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

### 4. 建立完整RA发行目录

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

### 5. 拷贝RA中文字体

目前RA的assets资源里自带一个中文字体`chinese-fallback-font.ttf`（在assets/pkg目录下），但是该字体仍然不完善，会有显示方块的问题。

建议使用[Maple Mono](chinese-fallback-font.ttf)字体。

- 低分辨屏（1080p及以下）建议使用`MapleMonoNL-CN-unhinted`（不含控制台图形字符、无连字、含中文、有渲染提示）
- 高分辨率屏（1080p以上）建议使用`MapleMonoNL-CN`（不含控制台图形字符、无连字、含中文、无渲染提示）

根据选择把下载好的字体regular版本更名为`chinese-fallback-font.ttf`，覆盖assets/pkg目录下同名文件。

### 6. 编译和分发RA模拟器内核

具体方法见下节。

## 模拟器内核编译和分发

> [!TIP]
>
> 使用脚本build_cores.sh, build_cores.cmd可自动化编译内核。
>
> 使用脚本dist_cores.sh可完成内核的分发。

### 通用内核编译方法

进入内核源代码目录，如果存在Makefile.libretro文件，运行：

```bash
make -f Makefile.libretro
```

如果不存在Makefile.libretro文件，直接运行：

```bash
make
```

裁剪，去除调试符号信息：

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

#### Final Burn Alpha 2012

需要在CFLAGS添加-Wno-incompatible-pointer-types，否则新版本gcc编译会出错。

```bash
export CFLGS="-Wno-incompatible-pointer-types"
make
```

#### Final Burn Alpha 2012 Neo Geo

需要在CFLAGS添加-Wno-incompatible-pointer-types，否则新版本gcc编译会出错。

```bash
export CFLGS="-Wno-incompatible-pointer-types"
make
```

#### bsnes

进入bsnes子目录，使用以下命令和参数编译：

```bash
cd bsnes
make -f GNUmakefile target="libretro" binary="library" local="false"
```

#### bsnes mercury/bsnes 2014

三个不同的profile，分别编译不同的配置。
```bash
make PROFILE=accuracy
make PROFILE=balanced
make PROFILE=performance
```

#### bsnes hd

进入bsnes子目录，使用以下命令和参数编译：

```bash
cd bsnes
make -f GNUmakefile target="libretro" binary="library"
```

#### ParaLLEl N64

添加编译参数`HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64`：

```bash
make HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64
```

#### Dolphin

1. 使用MinGW编译

   - 至当前（20250313）为止，MinGW自带的DirectX 11的头文件版本较老，缺少某些辅助结构的定义。要使用从[dxsdk](https://github.com/apitrace/dxsdk)获得的DirectX 11头文件进行编译。此处的头文件包中还包含DirectX 12的头文件，但是和当前MinGW不兼容，因此要删除其中DirectX 12的头文件。DirectX 11的头文件也需要一些修改，增加部分UUID的声明，否则链接时会出现错误：

     ```bash
     undefined reference to `_GUID const& __mingw_uuidof()
     ```

     该头文件包已添加至Dolphin源代码Externals/dxsdk下，并做好了需要的修改：删除其中DX12头文件，添加了需要的UUID声明。

     通过修改Dolphin的CMakeLists.txt文件，添加dxsdk的包含路径和库路径。

     编译Dolphin前，需要先编译dxsdk，生成MinGW可用的lib文件：

     ```bash
     cd Externals/dxsdk/Lib
     make DLLTOOL=dlltool
     ```

   - MinGW的fmt库太新，编译无法通过。通过修改Dolphin的CMakeLists.txt文件，使用Dolphin自带的fmt库。

   - Dolphin自带的curl库和MinGW不兼容，编译无法通过。通过修改Dolphin的CMakeLists.txt文件，使用MinGW的curl库。

   - Dolphin其他部分头文件、源文件和CMakeLists.txt要做适当修改才能在MinGW编译通过。

   完整编译命令：

   ```bash
   # 编译dxsdk
   make -C Externals/dxsdk/lib DLLTOOL=dlltool
   # 在Build目录下生成创建ninja make文件
   cmake -DLIBRETRO=ON -Wno-dev . -B Build
   # 编译
   cmake --build Build --target dolphin_libretro --config Release
   ```

2. 使用VS2022编译

   ```cmd
   # 在Build目录下生成创建VS文件
   cmake -DLIBRETRO=ON -Wno-dev . -B Build
   # 编译
   cmake --build Build --target dolphin_libretro --config Release -- /p:Platform=x64
   ```

#### melonDS DS

使用CMake编译：

```bash
cmake . -B Build
cmake --build Build
```

#### Citra

1. 使用MinGW编译：

   ```bash	
   # 在Build目录下生成创建ninja make文件
   cmake -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF -Wno-dev -DCMAKE_BUILD_TYPE="Release" . -B Build
   # 编译
   cmake --build Build --target citra_libretro --config Release
   ```

2. 使用VS2022编译：

   ```cmd
   # 在Build目录下生成创建VS2022项目文件
   cmake -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF -Wno-dev -DCMAKE_BUILD_TYPE="Release" . -B Build
   # 编译
   cmake --build Build --target citra_libretro --config Release -- /p:Platform=x64
   ```


#### Beetle PSX HW

和Beetle PSX同一源代码仓库，添加HAVE_HW=1参数编译硬件加速版本：
```bash
make HAVE_HW=1
```

#### PPSSPP

1. 使用MinGW编译

   第三方库子模块`ext/glslang`下的一个头文件需要修改后才能编译：

   ```bash
   # ext/glslang/glslang/MachineIndependent/SymbolTable.h 文件添加 #inlcude <cstdint>
   sed -i '0,/#include/{s/#include/#include <cstdint>\n#include/}' ext/glslang/glslang/MachineIndependent/SymbolTable.h
   ```

   编译命令：

   ```bash
   # 在Build目录下生成创建ninja make文件
   cmake -DLIBRETRO=ON -Wno-dev . -B Build
   # 编译
   cmake --build Build --target ppsspp_libretro --config Release
   ```

2. 使用VS2022编译

   ```cmd
   # 在Build目录下生成创建VS2022项目文件
   cmake -DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/MD /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MD /utf-8" -Wno-dev -DCMAKE_BUILD_TYPE="Release" . -B Build
   # 编译
   cmake --build Build --target ppsspp_libretro --config Release -- /p:Platform=x64
   ```

#### DOSBox Core

**不能使用ccache**，否则编译会出错。编译命令：

```bash
# 使用自带audio codec库和libsndfile库；静态链接c++库；静态链接系统库
# 首先编译依赖库，然后编译自身
make BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1 deps
make BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1
```
#### DOSBox Pure

1. 使用MinGW编译：

   ```bash
   # 添加参数 platform=windows
   make platform=windows
   ```

2. 使用VS2022编译：

   ```cmd
   msbuild dosbox_pure_libretro.vcxproj -p:Platform=x64;Configuration=Release
   ```

## 个人汉化模拟器内核列表

### Aracde 街机

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| MAME 2000                                                    | [libretro-mame2000](https://github.com/crazyqk2019/libretro-mame2000) | 2000 version of MAME (0.37b5) for libretro. Compatible with iMAME4All/MAME4Droid/MAME 0.37b5 |                |
| [MAME 2003-Plus](https://docs.libretro.com/library/mame2003_plus/) | [libretro-mame2003_plus](https://github.com/crazyqk2019/libretro-mame2003_plus) | Updated 2018 version of MAME (0.78) for libretro.            |                |
| [MAME 2010](https://docs.libretro.com/library/mame_2010/)    | [libretro-mame2010](https://github.com/crazyqk2019/libretro-mame2010) | Late 2010 version of MAME (0.139) for libretro.              |                |
| MAME 2015                                                    | [libretro-mame2015](https://github.com/crazyqk2019/libretro-mame2015) | Late 2014/Early 2015 version of MAME (0.160-ish) for libretro. |                |
| MAME 2016                                                    | [libretro-mame2016](https://github.com/crazyqk2019/libretro-mame2016) | Late 2016 version of MAME (0.174) for libretro.              |                |
| MAME                                                         | [libretro-mame](https://github.com/crazyqk2019/libretro-mame) | MAME - Multiple Arcade Machine Emulator                      |                |
| Final Burn Alpha 2012                                        | [libretro-fbalpha2012](https://github.com/crazyqk2019/libretro-fbalpha2012) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). |                |
| Final Burn Alpha 2012 CPS1                                   | [libretro-fbalpha2012_cps1](https://github.com/crazyqk2019/libretro-fbalpha2012_cps1) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Capcom CPS1. |                |
| Final Burn Alpha 2012 CPS2                                   | [libretro-fbalpha2012_cps2](https://github.com/crazyqk2019/libretro-fbalpha2012_cps2) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Capcom CPS2. |                |
| Final Burn Alpha 2012 CPS3                                   | [libretro-fbalpha2012_cps3](https://github.com/crazyqk2019/libretro-fbalpha2012_cps3) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Capcom CPS3. |                |
| Final Burn Alpha 2012 Neo Geo                                | [libretro-fbalpha2012_neogeo](https://github.com/crazyqk2019/libretro-fbalpha2012_neogeo) | Final Burn Alpha 2012. Port of Final Burn Alpha to Libretro (0.2.97.24). Standalone core for Neo Geo. |                |
| [Final Burn Neo](https://docs.libretro.com/library/fbneo/)   | [libretro-fbneo](https://github.com/crazyqk2019/libretro-fbneo) | FBNeo is the follow-up of the FinalBurn and FinalBurn Alpha emulators. |                |

----
### Nintendo GB/GBC/GBA

| 内核名称 | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| SameBoy  | [libretro-sameboy](https://github.com/crazyqk2019/libretro-sameboy)（分支为`buildbot`） | Gameboy and Gameboy Color emulator written in C              |                |
| Gearboy  | [libretro-gearboy](https://github.com/crazyqk2019/libretro-gearboy) | Game Boy / Gameboy Color emulator for iOS, Mac, Raspberry Pi, Windows, Linux and RetroArch |                |
| TGB Dual | [libretro-tgbdual](https://github.com/crazyqk2019/libretro-tgbdual) | libretro port of TGB Dual                                    |                |
| mGBA     | [libretro-mgba](https://github.com/crazyqk2019/libretro-mgba) | mGBA Game Boy Advance Emulator                               |                |

### Nintendo FC

| 内核名称                                                | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [FCEUmm](https://docs.libretro.com/library/fceumm/)     | [libretro-fceumm](https://github.com/crazyqk2019/libretro-fceumm) | FCEU "mappers modified" is an unofficial build of FCEU Ultra by CaH4e3, which supports a lot of new mappers including some obscure mappers such as one for unlicensed NES ROM's. |                |
| [Nestopia](https://docs.libretro.com/library/nestopia/) | [libretro-nestopia](https://github.com/crazyqk2019/libretro-nestopia) | Nestopia is a cycle accurate emulator for the NES/Famicom. This is the libretro port of the Nestopia emulator, based on the de facto upstream Nestopia JG fork. The libretro port contains an additional overclocking feature. |                |
|                                                         |                                                              |                                                              |                |

### Nintendo SFC

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| bsnes                                                        | [libretro-bsnes](https://github.com/crazyqk2019/libretro-bsnes) | bsnes is a Super Nintendo (SNES) emulator focused on performance, features, and ease of use. |                |
| [bsnes mercury](https://docs.libretro.com/library/bsnes_mercury_accuracy/) | [libretro-bsnes_mercury](https://github.com/crazyqk2019/libretro-bsnes_mercury) | bsnes-mercury is a fork of higan, aiming to restore some useful features that have been removed, as well as improving performance a bit. Maximum accuracy is still uncompromising; anything that affects accuracy is optional and off by default. |                |
| [bsnes 2014](https://docs.libretro.com/library/bsnes_accuracy/) | [libretro-bsnes2014](https://github.com/crazyqk2019/libretro-bsnes2014)（分支为`libretro`) |                                                              |                |
| bsnes hd                                                     | [libretro-bsnes_hd](https://github.com/crazyqk2019/libretro-bsnes_hd) | bsnes fork that adds HD video features                       |                |
| [bsnes jg](https://docs.libretro.com/library/bsnes-jg/)      | [libretro-bsnes_jg](https://github.com/crazyqk2019/libretro-bsnes_jg) | bsnes-jg is a cycle accurate emulator for the Super Famicom/Super Nintendo Entertainment System, including support for the Super Game Boy, BS-X Satellaview, and Sufami Turbo. |                |
| [Snes9x](https://docs.libretro.com/library/snes9x/)          | [libretro-snes9x](https://github.com/crazyqk2019/libretro-snes9x) | Port of upstream mainline **up-to-date** Snes9x, a portable Super Nintendo Entertainment System emulator to libretro. |                |

### Nintendo 64

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Mupen64Plus-Next](https://docs.libretro.com/library/mupen64plus/) | [libretro-mupen64plus_next](https://github.com/crazyqk2019/libretro-mupen64plus_next)（分支为`develop`） | Mupen64Plus-Next for libretro is an up-to-date port of Mupen64Plus, a Nintendo 64 emulator. |                |
| ParaLLEl N64                                                 | [libretro-parallel_n64](https://github.com/crazyqk2019/libretro-parallel_n64) | Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus. |                |
|                                                              |                                                              |                                                              |                |

### Nintendo GC/Wii

| 内核名称                                              | 汉化仓库地址                                                 | 内核说明 | 汉化时间和版本 |
| ----------------------------------------------------- | ------------------------------------------------------------ | -------- | -------------- |
| [Dolphin](https://docs.libretro.com/library/dolphin/) | [libretro-dolphin](https://github.com/crazyqk2019/libretro-dolphin) |          |                |
|                                                       |                                                              |          |                |
|                                                       |                                                              |          |                |

### Nintendo DS

| 内核名称                                                    | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ----------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [DeSmuME](https://docs.libretro.com/library/desmume/)       | [libretro-desmume](https://github.com/crazyqk2019/libretro-desmume) | DeSmuME is a Nintendo DS emulator [http://desmume.org](http://desmume.org/) |                |
| [melonDS DS](https://docs.libretro.com/library/melonds_ds/) | [libretro-melondsds](https://github.com/crazyqk2019/libretro-melondsds)（分支为`main`） | A Nintendo DS emulator (with DSi support) by Arisotura and friends, ported to libretro by Jesse Talavera. |                |
|                                                             |                                                              |                                                              |                |

### Nintendo 3DS

| 内核名称                                          | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Citra](https://docs.libretro.com/library/citra/) | [libretro-citra](https://github.com/crazyqk2019/libretro-citra) | Citra is an experimental open-source Nintendo 3DS emulator/debugger written in C++. It is written with portability in mind. |                |
|                                                   |                                                              |                                                              |                |

### Sega MS/GG/MD

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Genesis Plus GX](https://docs.libretro.com/library/genesis_plus_gx/) | [libretro-genesis_plus_gx](https://github.com/crazyqk2019/libretro-genesis_plus_gx) | An enhanced port of Genesis Plus - accurate & portable Sega 8/16 bit emulator |                |
| Genesis Plus Gx Wide                                         | [libretro-genesis_plus_gx_wide](https://github.com/crazyqk2019/libretro-genesis_plus_gx_wide)（分支为`main`） | Widescreen modification of Genesis Plus GX                   |                |
| [PicoDrive](https://docs.libretro.com/library/picodrive/)    | [libretro-picodrive](https://github.com/crazyqk2019/libretro-picodrive) | PicoDrive is an open-source Sega 8/16 bit and 32X emulator which was written having ARM-based handheld devices in mind. |                |

### Sega Saturn

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Beetle Saturn](https://docs.libretro.com/library/beetle_saturn/) | [libretro-mednafen_saturn](https://github.com/crazyqk2019/libretro-mednafen_saturn) | Standalone port of Mednafen Saturn to the libretro API.      |                |
| [Kronos](https://docs.libretro.com/library/yabause/)         | [libretro-kronos](https://github.com/crazyqk2019/libretro-kronos)（分支`kronos`） | Kronos is a fork of [Yabause](https://docs.libretro.com/library/yabause/). [It uses compute shaders](https://www.libretro.com/index.php/kronos-2-1-2-progress-report-sega-saturn-emulator/) and as such requires OpenGL 4.3. It emulates both the Sega Saturn and its arcade board version, the Sega Titan Video (ST-V). It's a fairly active project and the only Sega Saturn libretro core being officially supported by upstream. |                |
|                                                              |                                                              |                                                              |                |

### Sega DC/NAOMI/Atomiswave

| 内核名称                                              | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ----------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [flycast](https://docs.libretro.com/library/flycast/) | [libretro-flycast](https://github.com/crazyqk2019/libretro-flycast) | Flycast is a multiplatform Sega Dreamcast, Naomi, Naomi 2 and Atomiswave emulator |                |
|                                                       |                                                              |                                                              |                |
|                                                       |                                                              |                                                              |                |

### Sony PlayStation 1/2/3

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Beetle PSX](https://docs.libretro.com/library/beetle_psx/)<br />[Beetle PSX HW](https://docs.libretro.com/library/beetle_psx_hw/) | [libretro-mednafen_psx](https://github.com/crazyqk2019/libretro-mednafen_psx) | Standalone port/fork of Mednafen PSX to the Libretro API.    |                |
| [PCSX ReARMed](https://docs.libretro.com/library/pcsx_rearmed/) | [libretro-pcsx_rearmed](https://github.com/crazyqk2019/libretro-pcsx_rearmed) | PCSX ReARMed is a fork of PCSX Reloaded. It differs from the latter in that it has special optimizations for systems that have an ARM architecture-based CPU. |                |
|                                                              |                                                              |                                                              |                |

### Sony PSP/PSV

| 内核名称                                            | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| --------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [PPSSPP](https://docs.libretro.com/library/ppsspp/) | [libretro-ppsspp](https://github.com/crazyqk2019/libretro-ppsspp) | A PSP emulator for Android, Windows, Mac and Linux, written in C++. The PPSSPP core supports [OpenGL](https://docs.libretro.com/library/ppsspp/#opengl), [Vulkan](https://docs.libretro.com/library/ppsspp/#vulkan), and [Direct3D 11](https://docs.libretro.com/library/ppsspp/#d3d11) rendering. |                |
|                                                     |                                                              |                                                              |                |

### SNK NGP/NGPC

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明 | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | -------------- |
| [Beetle NeoPop](https://docs.libretro.com/library/beetle_neopop/) | [libretro-mednafen_ngp](https://github.com/crazyqk2019/libretro-mednafen_ngp) |          |                |
|                                                              |                                                              |          |                |

### SNK NeoCD

| 内核名称 | 汉化仓库地址                                                 | 内核说明                         | 汉化时间和版本 |
| -------- | ------------------------------------------------------------ | -------------------------------- | -------------- |
| NeoCD    | [libretro-neocd](https://github.com/crazyqk2019/libretro-neocd) | Neo Geo CD emulator for libretro |                |
|          |                                                              |                                  |                |

###  3DO

| 内核名称                                          | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Opera](https://docs.libretro.com/library/opera/) | [libretro-opera](https://github.com/crazyqk2019/libretro-opera) | Opera is an open-source, low-level emulator for the 3DO Game Console. Opera is a fork of 4DO, originally a port of 4DO, itself a fork of FreeDO, to libretro. The fork/rename occurred due to the original 4DO project being dormant and to differentiate the project due to new development and focus. |                |
|                                                   |                                                              |                                                              |                |

### NEC PC-Engine

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| Beetle PCE                                                   | [libretro-mednafen_pce](https://github.com/crazyqk2019/libretro-mednafen_pce) | This PC Engine module is more accurate than the Fast module, which trades away typically unneeded accuracy in favor of speed. Unlike [Beetle PCE Fast](https://github.com/libretro/beetle-pce-fast-libretro), Beetle PCE retains built-in SuperGrafx support. SuperGrafx support can alternatively be found in the [Beetle SuperGrafx core](https://github.com/libretro/beetle-supergrafx-libretro). |                |
| [Beetle PCE Fast](https://docs.libretro.com/library/beetle_pce_fast/) | [libretro-mednafen_pce_fast](https://github.com/crazyqk2019/libretro-mednafen_pce_fast) | Beetle/Mednafen PCE FAST is a libretro port of Mednafen PCE Fast with the PC Engine SuperGrafx module removed. |                |

### Microsoft MSX

| 内核名称                                        | 汉化仓库地址                                                 | 内核说明 | 汉化时间和版本 |
| ----------------------------------------------- | ------------------------------------------------------------ | -------- | -------------- |
| [fMSX](https://docs.libretro.com/library/fmsx/) | [ibretro-fmsx](https://github.com/crazyqk2019/libretro-fmsx) |          |                |
|                                                 |                                                              |          |                |

### Sharp X68000

| 内核名称                                          | 汉化仓库地址                                                 | 内核说明                                                     | 汉化时间和版本 |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [PX68k](https://docs.libretro.com/library/px68k/) | [libretro-px68k](https://github.com/crazyqk2019/libretro-px68k) | Portable SHARP X68000 Emulator for PSP, Android and other platforms |                |
|                                                   |                                                              |                                                              |                |

### DOS

| 内核名称                                                     | 汉化仓库地址                                                 | 内核说明 | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | -------------- |
| DOSBox Core                                                  | [libretro-dosbox_core](https://github.com/crazyqk2019/libretro-dosbox_core)（分支`libretro`） |          |                |
| [DOSBox Pure](https://docs.libretro.com/library/dosbox_pure/) | [libretro-dosbox_pure](https://github.com/crazyqk2019/libretro-dosbox_pure) |          |                |

## 项目目录和文件说明

### scripts目录 -- 安装/拉取/编译脚本

| 文件名              | 说明                                                         |
| ------------------- | ------------------------------------------------------------ |
| msys2shell.cmd      | 进入不同的msys2 shell环境，运行参数：`msys2shell.cmd <msys2安装目录> [mingw64|ucrt64|clang64]`<br />第二个参数指定进入哪个开发环境，省略则进入msys2环境。 |
| vc64shell.cmd       | 进入VC2022 64位编译环境，无参数直接运行。                    |
| inst_pkgs.sh        | 安装msys2开发环境所需的包和库。运行参数：`./inst_pkgs.sh <mingw64|ucrt64|clang64>` |
| clone_ra.sh         | 克隆RetroArch汉化库源代码到retrorch目录，并把原始RA仓库添加为上游仓库。 |
| clone_ra_orig.sh    | 克隆原始RetroArch源代码到retroarch_orig目录。                |
| clone_cores.sh      | 克隆汉化RA模拟器内核源码到cores目录下，并把原始内核仓库添加为上游仓库。 |
| build_ra.sh         | 编译RetroArch，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| build_ra_filters.sh | 编译RetroAch的音视频滤镜，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| build_cores.sh      | 编译RA模拟器内核。运行参数：`./build_cores.sh [-noclean] <all|core1 core2 ...>`<br />-noclean：编译前不要进行清理。<br />all: 编译所有内核。<br />core1 core2: 编译指定内核，不带参数运行脚本可以查看可用内核。<br />编译完成的内核文件为拷贝到`cores\dists`目录下 |
| build_cores.cmd     | 编译需要在VS2022下编译的RA模拟器内核，运行参数同上。         |
| dist_ra.sh          | 创建RetroArch分发目录retroarch_dist，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| dist_cores.sh       | 分发RA模拟器内核到retroarch_dist目录，运行参数：`./dist_cores.sh [all|core1.dll core2.dll...]`<br />此脚本在默认内核编译输出目录`cores\dists`下寻找内核。 |

### tools目录 -- 需要用到的一些第三方工具

| 文件名      | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| vswhere.exe | 用于查找VS安装信息。来自于<https://github.com/microsoft/vswhere> |
| python.7z   | Python3 嵌入版，解压后用于VS2022编译                         |

## 其他问题

### 如何同步上游仓库更新

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

### 如何处理git换行符问题

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




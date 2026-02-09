# Windows 下 RetroArch 的编译

## 快速使用

- 进入项目的`scripts`目录，按序执行以下脚本。

- 安装Msys2/MinGW编译环境和Visual C++编译环境：

  ```cmd
  .\env_setup\setup_msys2.cmd
  .\env_setup\setup_vc.cmd
  ```

  以上编译环境皆为绿色版，不会在系统目录和注册表写入文件和信息。

- 进入VC编译环境，编译安装 libsmb2 库（可选，RA的可选依赖库，没有也不影响使用）：

  ```cmd
  vc64shell.cmd env_setup\inst_libsmb2.cmd
  ```
  
- 进入 msys2 环境：

  ```cmd
  msys2shell.cmd
  ```

- 拉取RA源代码和模拟器内核源代码：

  ```bash
  ./clone_ra.sh
  ./clone_cores.sh all
  ```

- 编译RA和音视频滤镜：

  ```bash
  ./build_ra.sh ../retroarch
  ./build_ra_filters.sh ../retroarch
  ```

- 编译模拟器内核：

  ```bash
  ./build_cores.sh all
  ```

- 部分内核只能使用VC编译，进入VC编译环境进行编译：

  ```cmd
  vc64shell.cmd build_cores.cmd all
  ```
  
- 分发所有编译结果，下载其他资源文件。最终结果将在`retroarch_dist`目录中：

  ```bash
  ./dist_ra.sh ../retrorach
  ./dist_cores.sh all
  ```

> [!IMPORTANT]
>
> 拉取源代码和部分内核的编译过程会访问github等网站，部分网站包括github在国内访问不稳定或者无法访问，需要架梯子。否则可能会造成拉取失败或者编译失败。

## 一、编译环境搭建

在Windows下编译RetroArch和所有模拟器内核，同时需要MSys2/MinGW编译环境和Visual C++编译环境。

RA自身使用msys2/mingw编译，但是某些内核只能在Visual C++下编译。

> [!TIP]
>
> 编译环境搭建完成以后，不建议频繁升级，尤其是MSys2/MinGW，升级常常会带来新的问题，导致一些编译错误。

### MSys2/MinGW 编译环境搭建

参见子模块说明：[MSys2/MinGW 编译环境安装](.\scripts\env_setup\msys2_dev_env\README.md)

本项目默认使用ucrt64编译工具链进行编译，而不是使用官方推荐的mingw64编译工具链。

> [!Note]
>
> 运行`scripts\env_setup\setup_msys2.cmd`可自动完成MSys2/MinGW编译环境搭建。

### Visual C++ 编译环境搭建

1. 安装Visual C++编译工具

- （不使用此方法）安装Visual Studio完整版，Community版本即可，安装时注意选中VC开发和Windows SDK。

  下载地址：<https://visualstudio.microsoft.com/zh-hans/vs/>

  Visual Studio 最新Community版本安装文件下载地址：https://aka.ms/vs/stable/vs_community.exe

  Visual Studio 2022 版本Community安装文件下载地址：https://aka.ms/vs/17/release/vs_community.exe

- 使用[PortableBuildTools](https://github.com/Data-Oriented-House/PortableBuildTools)创建绿色版VC编译器。由于绿色版VC不包含msbuild工具，无法直接编译.vcxproj文件和.sln文件，需要使用另一个工具[vcxproj2cmake](https://github.com/chausner/vcxproj2cmake)转换vcxproj文件或.sln为CMake文件（CMakeLists.txt），然后再用CMake编译。

2. git，绿色busybox最小版即可。

3. CMake，如果安装了完整版Visual Studio，VS自带的CMake不能用，必须要独立版本的CMake，同样可以使用绿色版本。<https://cmake.org/download/>

4. Python，部分内核编译需要Python，可使用embedded绿色版本的Python，手动安装pip和setuptools包。方法如下：

   - 解压embedded版本Python压缩包，编辑python313._pth文件，去掉`#import site`前的注释。313为当前python的版本号，文件名根据版本号不同。

   - 下载get-pip.py脚本：

   ```cmd
   curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
   ```

   - 运行以下命令安装pip：

   ```cmd
   python get-pip.py
   ```

   - 运行以下命令安装setuptools包：

   ```cmd
   Scripts\pip install setuptools
   ```

5. Ninja，[官网下载](https://github.com/ninja-build/ninja/releases)

6. vcxproj2cmake，[官网下载](https://github.com/chausner/vcxproj2cmake/releases)。

7. PortableBuildTools 和 vcxproj2cmake 都需要.NET 10运行库，下载：<https://dotnet.microsoft.com/zh-cn/download/dotnet/10.0>

> [!NOTE]
>
> 运行`scripts\env_setup\setup_vc.cmd`可自动完成Visual C++编译环境搭建。

### 需要单独编译安装的第三方库

#### capsimage

读取IPF磁盘镜像格式的API，这是由[Software Preservation Society (SPS)](http://www.softpres.org/)设计推出的一种老式计算机软件和游戏的磁盘镜像格式。部分模拟器要支持IPF镜像读取的话，需要这个API。

可从此处<http://www.softpres.org/download>下载二进制运行库和头文件，从此处<https://www.kryoflux.com/?page=download>下载5.1版本的源码。

无法下载到4.2的源码，但是5.1和4.2的版本在API层面应该是兼容的，所以可以编译5.1版本的源码，安装5.1版本的运行库和头文件，然后再下载安装4.2版本的头文件，可以同时兼容两个版本。

1. MinGW版本编译安装

   下载5.1源码<https://www.kryoflux.com/download/spsdeclib_5.1_source.zip>

   解压后包含linux和windows两个版本的源码，MinGW使用linux版本源码编译。

   编译命令：

   ```bash
   # 进入源码目录
   cd capsimg_source_linux_macosx\CAPSImg
   # 重新生成configure
   autoconf
   # 运行configure
   ./configure
   # 编译
   make
   # 安装运行库和链接库
   install -v capsimg.dll "$MINGW_PREFIX/bin"
   install -v capsimg.dll.a "$MINGW_PREFIX/lib"
   # 安装头文件
   install -v -D ../LibIPF/*.h "$MINGW_PREFIX/include/caps5/"
   install -v -D ../Core/CommonTypes.h "$MINGW_PREFIX/usr/include/caps5/CommonTypes.h"
   ```

   下载4.2版本：<http://www.softpres.org/_media/files:ipflib42_linux-x86_64.tar.gz>

   解压后安装4.2版本头文件：

   ```bash
   cd x86_64-linux-gnu-capsimage
   install -v -D include/caps/*.h $MINGW_PREFIX/include/caps/
   ```

2. Visual C++ 版本编译安装

   暂无

#### libsmb2

RA的可选依赖库，目前该库Windows下只能在Visual C++环境编译。因此需要用VC编译以后再安装到msys2编译环境。

使用CMake编译，注意生成的libsmb2.pc文件要更改里面的路径名称以适配msys2环境。

具体编译安装步骤见脚本`scripts\env_setup\inst_libsmb2.cmd`

## 二、编译和分发 RetraoArach

###  1. 拉取 RA 源代码

1. 进入msys2环境，执行：

   ```bash
   git clone https://github.com/libretro/RetroArch retroarch
   ```

2. ~~完成后进入retroarch源代码目录，执行拉取子模块脚本：~~（子模块为资源，可以直接在<https://buildbot.libretro.com/assets/frontend/>下载打包好的资源）

   ```bash
   ./fetch-submodules.sh
   ```

> [!Note]
>
> 可使用`scripts/clone_ra.sh`脚本自动执行拉取。

### 2. 编译 RA 主程序

1. 进入msys2编译环境：

   ```cmd
   msys2_shell.cmd -ucrt64 -defterm -no-start
   ```

2. 进入RA源代码目录，运行配置程序：

   ```bash
   ./configure
   ```

3. 编译：

   ```bash
   make -j
   ```
   
4. 裁剪优化，减小可执行文件大小：

   ```bash
   strip -s retroarch.exe
   ```

> [!Note]
>
> 可使用`scripts/build_ra.sh`脚本自动执行以上编译步骤。

### 3. 编译视频滤镜和音频滤镜

1. 编译视频滤镜：

   ```bash
   cd gfx/video_filters
   make -j
   ```

2. 编译音频滤镜(DSP)：

   ```bash
   cd libretro-common/audio/dsp_filters
   make -j
   ```

> [!Note]
>
> 可使用`scripts/build_ra_filters.sh`脚本自动编译视频滤镜和音频DSP。

### 4. 建立完整 RA 发行目录

1. 拷贝retroarch.exe到分发目录。

2. 拷贝依赖的msys和mingw的dll:

   ```bash
   for bin in $(ntldd -R retroarch.exe | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2);
   	do cp -v "$bin" .
   done
   ```

3. 拷贝依赖的Qt的dll:

   ```bash
   windeployqt6 retroarch.exe
   for bin in $(ntldd -R imageformats/*dll | grep -i ucrt64 | cut -d">" -f2 | cut -d" " -f2);
   	do cp -v "$bin" .
   done
   ```

4. 拷贝音视频滤镜：

   ```bash
   mkdir -p ../retroarch_dist/filters/video
   cp -t ../retroarch_dist/filters/video gfx/video_filters/*.dll gfx/video_filters/*.filt
   mkdir -p ../retroarch_dist/filters/audio
   cp -t ../retroarch_dist/filters/audio libretro-common/audio/dsp_filters/*.dll libretro-common/audio/dsp_filters/*.dsp
   ```

5. 从<https://buildbot.libretro.com/assets/frontend/>下载其他资源并解压到RA根目录下对应子目录:

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

> [!Note]
>
> 可使用`scripts\dist_ra_filters.sh`脚本自动执行以上步骤。

### 5. 中文字体问题

目前 RA 的 assets 资源里自带一个中文字体`chinese-fallback-font.ttf`（在assets/pkg目录下），但是该字体仍然不完善，会有显示方块的问题。

推荐使用[Sarasa Term SC Nerd](https://github.com/laishulu/Sarasa-Term-SC-Nerd)字体。

根据选择把下载好的字体 regular 版本更名为`chinese-fallback-font.ttf`，覆盖assets/pkg目录下同名文件。

### 6. 编译和分发模拟器内核

模拟器内核编译具体方法见下节。

分发内核时除了要拷贝内核本身的dll文件外，还要拷贝所有依赖的dll文件。

```bash
for i in $(seq 3); do 
	for dll in $(ntldd -R cores/$core_file | grep -i msys64 | cut -d">" -f2 | cut -d" " -f2); do
		cp -v "$dll" .
	done
done
```



## 三、模拟器内核的编译方法

> [!Note]
>
> - 使用脚本`build_cores.sh`可以自动编译使用MSys2/MinGW编译的内核。
>
> - 使用脚本`build_cores.cmd`可以自动编译使用VC编译的内核。
>
> - 使用脚本`dist_cores.sh`可完成内核的分发。

### 内核编译方式

目前内核的编译方式可分为三种：

1. 大部分内核在msys2环境下直接使用make编译。

   进入内核源代码目录，如果存在Makefile.libretro文件则使用，否则使用默认Makefile文件。

   ```bash
   make -f Makefile.libretro -j
   # 或者
   make -j
   strip -s core_name_libretro.dll # 裁剪，去除调试符号信息
   ```

2. 部分内核在msys2或者VC环境下使用CMake编译。

   进入内核源代码目录，先运行cmake生成Ninja编译配置文件，然后再编译。

   ```bash
   cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -G Ninja -B build_dir
   cmake --build build_dir --target ${core}_libretro --config Release -j
   strip -s ${core}_libretro.dll # 裁剪，去除调试符号信息，msys2 环境编译执行此步骤
   ```

   > [!NOTE]
   >
   > msys2环境下也可以生成msys makefiles或者mingw makefiles进行编译；
   >
   > VC环境下也可以生成NMake makefiles调用nmake进行编译，或者生成Visual Studio 项目文件调用msbuild进行编译（需要安装Visual Studio）。
   >
   > 为方便起见，统一都生成ninja文件进行编译。

   使用CMake编译的内核列表：

   | 内核名称                                         | MSys2/MinGW CMake编译             | Visual C++ CMake编译           | 个人推荐的编译器 |
   | ------------------------------------------------ | --------------------------------- | ------------------------------ | ---------------- |
   | [Dolphin（NGC/Wii模拟器）](#dolphin)             | ✅[支持](#dolphin_msys2_cmake)​     | ✅[支持](#dolphin_vc_cmake)     | Visual C++       |
   | [melonDS DS（NDS模拟器）](#melondsds)            | ✅[支持](#melondsds_msys2_cmake)   | ❎不支持                        | MSys2/MinGW      |
   | [Citra（3DS模拟器）](#citra)                     | ✅[支持](#citra_msys2_cmake)       | ✅[支持](#citra_vc_cmake)       | Visual C++       |
   | [Flycast（DC/Naomi/Atomiswave模拟器）](#flycast) | ✅[支持](#flycast_msys2_cmake)     | ❎不支持                        | MSys2/MinGW      |
   | [PPSSPP（PSP模拟器）](#ppsspp)                   | ✅[支持](#ppsspp_msys2_cmake)      | ✅[支持](#ppsspp_vc_cmake)      | MSys2/MinGW      |
   | [Play!（PS2模拟器）](#play)                      | ❎不支持                           | ✅[支持](#play_vc_cmake)        | Visual C++       |
   | [PCSX2(LRPS2)（PS2模拟器）](#lrps2)              | ❎不支持                           | ✅[支持](#lrps2_vc_cmake)       | Visual C++       |
   | [SwanStation（PS1模拟器）](#swanstation)         | ❎不支持                           | ✅[支持](#swanstation_vc_cmake) | Visual C++       |
   | [DOSBox Pure（DOS模拟器）](#dosboxpure)          | ❎不支持（使用make编译）           | ✅[支持](#dosboxpure_vc_cmake)  | Visual C++       |
   | [TIC-80（TIC-80模拟器）](#tic80)                 | ✅[支持](#tic80_msys2_cmake)       | ✅[支持](#tic80_vc_cmake)       | MSys2/MinGW      |
   | [SquirrelJME（JavaME 8虚拟机）](#squirreljme)    | ✅[支持](#squirreljme_msys2_cmake) | ❎不支持                        | MSys2/MinGW      |

3. msys2环境下使用其他工具编译的内核。

   目前只有内核 [holani](#holani_msys2_cargo)（Atari Lynx模拟器）使用 cargo 编译工具（msys2环境下）进行编译。

> [!CAUTION]
>
> CMake升级到4.0以后，部分使用CMake编译的项目，要在命令行添加`-DCMAKE_POLICY_VERSION_MINIMUM=3.5`参数，否则会报错。

### 需要特别说明或者需要修正的内核编译

内核编译说明索引，不在此列表中的内核都使用MSys2/MinGW环境通用make编译参数进行编译：

| 内核名称                                                     | MSys2/MinGW编译方式 | Visual C++编译方式 |
| ------------------------------------------------------------ | ------------------- | ------------------ |
| [MAME（多机种街机模拟器）](#mame_msys2_make)                 | make                | ❎不支持            |
| [MAME 2015（多机种街机模拟器）](#mame2015_msys2_make)        | make                | ❎不支持            |
| [MAME 2016（多机种街机模拟器）](#mame2016_msys2_make)        | make                | ❎不支持            |
| [HBMAME（多机种街机模拟器）](#hbmame_msys2_make)             | make                | ❎不支持            |
| [Final Burn Alpha 2012（多机种街机模拟器）](#fba2012_msys2_make) | make                | ❎不支持            |
| [Final Burn Alpha 2012 NeoGeo（多机种街机模拟器）](#fba2012neogeo_msys2_make) | make                | ❎不支持            |
| [Neko Project II Kai（PC-9801系列机型模拟器）](#nekoprojectiikai_msys2_make) | make                | ❎不支持            |
| [bsnes（SFC/SNES模拟器）](#bsnes_msys2_make)                 | make                | ❎不支持            |
| [bsnes mercury & 2014（SFC/SNES模拟器）](#bsnesmercury2014_msys2_make) | make                | ❎不支持            |
| [bsnes hd（SFC/SNES模拟器）](#bsneshd_msys2_make)            | make                | ❎不支持            |
| [ParaLLEl N64（N64模拟器）](#paralleln64_msys2_make)         | make                | ❎不支持            |
| [Dolphin（NGC/Wii模拟器）](#dolphin_build)                   | CMake               | CMake              |
| [melonDS DS（NDS模拟器）](#melondsds_msys2_cmake)            | CMake               | ❎不支持            |
| [Citra（3DS模拟器）](#citra_build)                           | CMake               | CMake              |
| [Flycast（DC/Naomi/Atomiswave模拟器）](#flycast_msys2_cmake) | CMake               | ❎不支持            |
| [Beetle PSX HW（PS1模拟器）](#beetlepsxhw_msys2_make)        | make                | ❎不支持            |
| [SwanStation（PS1模拟器）](#swanstation_vc_cmake)            | ❎不支持             | CMake              |
| [Play!（PS2模拟器）](#play_vc_cmake)                         | ❎不支持             | CMake              |
| [PCSX2（PS2模拟器）](#lrps2_vc_cmake)                        | ❎不支持             | CMake              |
| [PPSSPP（PSP模拟器）](#ppsspp_build)                         | CMake               | CMake              |
| [DOSBox Core（DOS模拟器）](#dosboxcore_msys2_make)           | make                | ❎不支持            |
| [DOSBox Pure（DOS模拟器）](#dosboxpure_build)                | make                | CMake              |
| [ep128emu（Z80系列家用计算机模拟器）](#ep128emu_msys2_make)  | make                | ❎不支持            |
| [ScummVM（开源的跨平台游戏引擎）](#scummvm_msys2_make)       | make                | ❎不支持            |
| [SquirrelJME（JavaME 8虚拟机）](#squirreljme_msys2_cmake)    | CMake               | ❎不支持            |
| [TIC-80（TIC-80模拟器）](#tic80_build)                       | CMake               | CMake              |
| [Hatari（Atari ST/STE/TT/Falcon模拟器）](#hatari_msys2_make) | make                | ❎不支持            |
| [Holani（Atari Lynx模拟器）](#holani_msys2_cargo)            | Cargo               | ❎不支持            |

* <span id="mame_msys2_make"> </span>**MAME**

  MSys2/MinGW环境使下使用make编译。

  目前仅需要修改`Makefile.libretro`，增加对ucrt64编译器的识别。

  > [!WARNING]
  >
  > MAME编译非常消耗内存，内存不够很容造成编译出错。
  >
  > 实测32GB内存机器，8线程CPU，默认8线程编译会内存耗尽而出错。
  >
  > 如果机器内存小于64GB，建议添加参数-j ，限制并行编译线程数。

  - ~~修正第三方库sol2在高版本gcc下的编译错误。参考来源：[Fix SOL2 build on GCC 10.2 by working around overload resolution problem](https://github.com/ajrhacker/mame/commit/dcbee7cda6faea688605ed24c2548187cb55f60a)~~

  - ~~修正部分头文件高版本gcc下的编译错误。~~

  - ~~修正genie生成MinGW下的链接命令的错误，不适用static链接。~~

  - ~~需要在make命令行指定使用python3。~~

    ```bash
    make PYTHON_EXECUTABLE=python3
    ```

* <span id="mame2015_msys2_make"> </span>**MAME 2015**

  MSys2/MinGW环境使下使用make编译。

  需要在make命令行添加"CC=g++"参数，指定使用g++编译，否则链接时会出错，找不到c++的部分库。

  ```bash
  make CC=g++
  ```

* <span id="mame2016_msys2_make"> </span>**MAME 2016**

  MSys2/MinGW环境使下使用make编译。

  需要在make命令行指定使用python3。

  ```bash
  make PYTHON_EXECUTABLE=python3
  ```

* <span id="hbmame_msys2_make"> </span>**HBMAME**

  MSys2/MinGW环境使下使用make编译。

  - 修正使用Python3时的编译错误。
  - 修正第三方库sol2在高版本gcc下的编译错误。参考来源：[Fix SOL2 build on GCC 10.2 by working around overload resolution problem](https://github.com/ajrhacker/mame/commit/dcbee7cda6faea688605ed24c2548187cb55f60a)
  - 修正部分头文件高版本gcc下的编译错误。
  - 修正genie生成的链接命令缺少空格的问题。
  - 修正genie生成MinGW下的链接命令的错误，不适用static链接。
  - 需要在make命令行指定使用python3。

  部分第三方库使用系统库而不是使用自带库：

  ```bash
  make PYTHON_EXECUTABLE=python3 NO_USE_MIDI=0 NO_USE_PORTAUDIO=0 USE_SYSTEM_LIB_EXPAT=1 USE_SYSTEM_LIB_ZLIB=1 USE_SYSTEM_LIB_JPEG=1 USE_SYSTEM_LIB_FLAC=1 USE_SYSTEM_LIB_SQLITE3=1 USE_SYSTEM_LIB_PORTMIDI=1 USE_SYSTEM_LIB_PORTAUDIO=1 USE_SYSTEM_LIB_UTF8PROC=1 USE_SYSTEM_LIB_GLM=1 USE_SYSTEM_LIB_RAPIDJSON=1 USE_SYSTEM_LIB_PUGIXML=1 USE_BUNDLED_LIB_SDL2=0
  ```

* <span id="fba2012_msys2_make"> </span>**Final Burn Alpha 2012**

  MSys2/MinGW环境使下使用make编译。

  需要在CFLAGS添加-Wno-incompatible-pointer-types，否则新版本gcc编译会出错。

  ```bash
  export CFLGS="-Wno-incompatible-pointer-types"
  make
  ```

* <span id="fba2012neogeo_msys2_make"> </span>**Final Burn Alpha 2012 NeoGeo**

  MSys2/MinGW环境使下使用make编译。

  需要在CFLAGS添加-Wno-incompatible-pointer-types，否则新版本gcc编译会出错。

  ```bash
  export CFLGS="-Wno-incompatible-pointer-types"
  make
  ```

* <span id="nekoprojectiikai_msys2_make"> </span>**Neko Project II Kai**

  MSys2/MinGW环境使下使用make编译。

  需要在CFLAGS添加-Wno-incompatible-pointer-types，否则新版本gcc编译会出错。

  ```bash
  export CFLGS="-Wno-incompatible-pointer-types"
  make
  ```

* <span id="bsnes_msys2_make"> </span>**bsnes**

  MSys2/MinGW环境使下使用make编译。

  进入bsnes子目录，添加编译参数`-f GNUmakefile target="libretro" binary="library" local="false"`：

  ```bash
  cd bsnes
  make -f GNUmakefile target="libretro" binary="library" local="false"
  ```

* <span id="bsnesmercury2014_msys2_make"> </span>**bsnes mercury & 2014**

  MSys2/MinGW环境使下使用make编译。

  这两个模拟器内核都有精确，平衡和性能三个不同的配置，要分别编译。

  ```bash
  make PROFILE=accuracy
  make PROFILE=balanced
  make PROFILE=performance
  ```

* <span id="bsneshd_msys2_make"> </span>**bsnes hd**

  MSys2/MinGW环境使下使用make编译。

  进入bsnes子目录，添加编译参数`-f GNUmakefile target="libretro" binary="library"`：

  ```bash
  cd bsnes
  make -f GNUmakefile target="libretro" binary="library"
  ```

* <span id="paralleln64_msys2_make"> </span>**ParaLLEl N64**

  MSys2/MinGW环境使下使用make编译。

  添加编译参数`HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64`：

  ```bash
  make HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 WITH_DYNAREC=x86_64
  ```

* <span id="dolphin_build"> </span>**Dolphin**
  
  同时支持使用MSys/MinGW和Visual C++编译。
  
  + <span id="dolphin_msys2_cmake"> </span>MSys2/MinGW环境使下使用CMake编译
  
    目前官方库已修复以下编译问题，无需再修正，只需添加参数`-DLIBRETRO=ON`即可。
  
    - ~~至当前（20250313）为止，MinGW自带的DirectX 11的头文件版本较老，缺少某些辅助结构的定义。要使用从[dxsdk](https://github.com/apitrace/dxsdk)获得的DirectX 11头文件进行编译。此处的头文件包中还包含DirectX 12的头文件，但是和当前MinGW不兼容，因此要删除其中DirectX 12的头文件。DirectX 11的头文件也需要一些修改，增加部分UUID的声明，否则链接时会出现错误：~~
  
      ```bash
      undefined reference to `_GUID const& __mingw_uuidof()
      ```
      
      ~~该头文件包已添加至Dolphin源代码Externals/dxsdk下，并做好了需要的修改：删除其中DX12头文件，添加了需要的UUID声明。~~
  
      ~~通过修改Dolphin的CMakeLists.txt文件，添加dxsdk的包含路径和库路径。~~
  
      ~~编译Dolphin前，需要先编译dxsdk，生成MinGW可用的lib文件：~~
  
      ```bash
      cd Externals/dxsdk/Lib
      make DLLTOOL=dlltool
      ```
      
    - ~~MinGW的fmt库太新，编译无法通过。通过修改Dolphin的CMakeLists.txt文件，使用Dolphin自带的fmt库。~~
  
    - ~~Dolphin自带的curl库和MinGW不兼容，编译无法通过。通过修改Dolphin的CMakeLists.txt文件，使用MinGW的curl库。~~
  
    - ~~Dolphin其他部分头文件、源文件和CMakeLists.txt要做适当修改才能在MinGW编译通过。~~
  
    ~~完整编译命令：~~
  
    ```bash
    # 编译dxsdk
    make -C Externals/dxsdk/lib DLLTOOL=dlltool
    # 在Build目录下生成创建ninja make文件
    cmake -DLIBRETRO=ON -Wno-dev -DCMAKE_BUILD_TYPE=Release . -B Build
    # 编译
    cmake --build Build --config Release --target dolphin_libretro
    ```
  
   + <span id="dolphin_vc_cmake"> </span>Visual C++环境使下使用CMake编译
  
     使用通用CMake编译命令进行编译。
  
* <span id="flycast_msys2_cmake"> </span>**Flycast**

  MSys2/MinGW环境使下使用CMake编译，添加额外参数`-DLIBRETRO=ON`

* <span id="melondsds_msys2_cmake"> </span>**melonDS DS**

  MSys2/MinGW环境使下使用CMake编译。
  
  需要更新依赖工具[embed-binaries](https://github.com/andoalon/embed-binaries)到新版本，以解决和CMake 4.2及以上版本的兼容性问题。问题参考链接：
  
  [Fails to generate embedded source files in CMake 4.2](https://github.com/andoalon/embed-binaries/issues/1)
  
  > [!IMPORTANT]
  >
  > gcc 5.1 和 5.2 版本有一个bug，会导致编译器在最后连接阶段出错，错误是由于LTO（连接时优化器）引起的，临时解决方案就是额外添加一个CMake参数以关闭LTO：
  >
  > `-DENABLE_LTO_RELEASE=OFF`
  >
  > 该bug已经修复，等待 gcc 5.3 版本发布应该就可以解决这个问题，而不用添加以上参数了。

* <span id="citra_build"> </span>**Citra**

  同时支持使用MSys/MinGW和Visual C++编译。

  + <span id="citra_msys2_cmake"> </span>MSys2/MinGW环境使下使用CMake编译，生成Ninja编译文件须添加额外参数：

    `-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF -DDISABLE_CLANG_TARGET=ON -DENABLE_LTO=OFF -DENABLE_TESTS=OFF -DENABLE_DEDICATED_ROOM=OFF -DENABLE_SCRIPTING=OFF -DENABLE_OPENAL=OFF -DENABLE_LIBUSB=OFF -DCITRA_ENABLE_BUNDLE_TARGET=OFF -DENABLE_CUBEB=OFF -DUSE_SYSTEM_GLSLANG=ON`

  

   > [!Caution]
   >
   > 2026/02/03 修正了一个编译错误 ，修改文件为`src\common\file_util.cpp`，该错误可能是由于新版gcc自身的bug导致，后续升级gcc时可尝试还原此更改。

  + <span id="citra_vc_cmake"> </span>Visual C++环境下使用CMake编译，生成Ninja编译文件须添加额外参数：

    `-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF -DDISABLE_CLANG_TARGET=ON -DENABLE_LTO=OFF -DENABLE_TESTS=OFF -DENABLE_DEDICATED_ROOM=OFF -DENABLE_SCRIPTING=OFF -DENABLE_OPENAL=OFF -DENABLE_LIBUSB=OFF -DCITRA_ENABLE_BUNDLE_TARGET=OFF -DENABLE_CUBEB=OFF`

* <span id="beetlepsxhw_msys2_make"> </span>**Beetle PSX HW**

  MSys2/MinGW环境使下使用make编译。

  和Beetle PSX同一源代码仓库，添加HAVE_HW=1参数编译硬件加速版本：
  ```bash
  make HAVE_HW=1
  ```

* <span id="swanstation_vc_cmake"> </span>**SwanStation**

  在Visual C++环境下使用通用CMake参数编译，不支持MSys/MinGW下编译。

* <span id="ppsspp_build"> </span>**PPSSPP**

  同时支持使用MSys/MinGW和Visual C++编译。

  + <span id="ppsspp_msys2_cmake"> </span>MSys2/MinGW环境使下使用CMake编译，生成Ninja编译文件须添加额外参数：

    `-DLIBRETRO=ON -DCMAKE_C_FLAGS=-Wno-incompatible-pointer-types`

    `Core\System.cpp`文件须修改，添加`#include <cstdint>`

    ~~第三方库子模块`ext/glslang`下的一个头文件`SymbolTable.h`需要修改，添加`#inlcude <cstdint>`：~~

    ```bash
    # ext/glslang/glslang/MachineIndependent/SymbolTable.h 文件添加 #inlcude <cstdint>
    sed -i '0,/#include/{s/#include/#include <cstdint>\n#include/}' ext/glslang/glslang/MachineIndependent/SymbolTable.h
    ```

  + <span id="ppsspp_vc_cmake"> </span>Visual C++环境下使用CMake编译，生成Ninja编译文件须添加额外参数：

    `-DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/DNOMINMAX" -DCMAKE_CXX_FLAGS_RELEASE="/DNOMINMAX"`

* <span id="play_vc_cmake"> </span>**Play!**

  在Visual C++环境下使用通用CMake参数编译，不支持MSys/MinGW下编译。

  生成Ninja编译文件须添加额外参数：`-DBUILD_PLAY=OFF -DBUILD_LIBRETRO_CORE=ON -DBUILD_TESTS=OFF`

* <span id="lrps2_vc_cmake"> </span>**PCSX2 (LRPS2)**

  在Visual C++环境下使用通用CMake参数编译，不支持MSys/MinGW下编译。

  生成Ninja编译文件须添加额外参数：`-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DLIBRETRO=ON`

  以及：` -DCMAKE_C_FLAGS_RELEASE="/utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/utf-8"`强制以UTF-8编码打开源码文件，以避免编译时抛出以下警告：

  ```
  warning C4819: The file contains a character that cannot be represented in the current code page (936). Save the file in Unicode format to prevent data loss
  ```

* <span id="dosboxcore_msys2_make"> </span>**DOSBox Core**

  MSys2/MinGW环境使下使用make编译。

  **不能使用ccache**，否则编译会出错。

  使用自带audio codec库和libsndfile库；静态链接c++库；静态链接系统库

  编译命令：

  ```bash
  # 首先编译依赖库，然后编译自身
  make BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1 deps
  make BUNDLED_AUDIO_CODECS=1 BUNDLED_LIBSNDFILE=1 STATIC_LIBCXX=1 STATIC_PACKAGES=1
  ```

* <span id="dosboxpure_build"> </span>**DOSBox Pure**

  同时支持使用MSys/MinGW和Visual C++编译。

  + <span id="dosboxpure_msys2_make"> </span>MSys2/MinGW环境使下使用make编译

    ```bash
    # 添加参数 platform=windows
    make platform=windows
    ```

  + <span id="dosboxpure_vc_cmake"> </span>Visual C++环境下先用vcxproj2cmake把dosbox_pure_libretro.vcxproj转换为CMake项目，再用CMake编译。

    ```cmd
    vcxproj2cmake --projects dosbox_pure_libretro.vcxproj
    ```

* <span id="hatari_msys2_make"> </span>**Hatari**

  MSys2/MinGW环境使下使用make编译。

  支持IPF格式需要[安装capsimage库](#capsimage)；`Makefile.libretro`已为编译做适当修改。

* <span id="ep128emu_msys2_make"> </span>**ep128emu**

  MSys2/MinGW环境使下使用make编译。

  添加参数`platform=win64`

  ```bash
  make platform=win64
  ```

* <span id="scummvm_msys2_make"> </span>**ScummVM**

  MSys2/MinGW环境使下使用make编译。

  添加参数以使用部分系统自带库：

  ```bash
  make USE_SYSTEM_fluidsynth=1 USE_SYSTEM_FLAC=1 USE_SYSTEM_vorbis=1 USE_SYSTEM_z=1 USE_SYSTEM_mad=1 USE_SYSTEM_faad=1 USE_SYSTEM_png=1 USE_SYSTEM_jpeg=1 USE_SYSTEM_theora=1 USE_SYSTEM_freetype=1 USE_SYSTEM_fribidi=1
  ```
  编译 coreinfo：
  ```bash
  make coreinfo
  ```
  编译 datafiles/themes (`scummvm.zip`)：
  ```bash
  make datafiles
  ```

* <span id="squirreljme_msys2_cmake"> </span>**SquirrelJME**

  MSys2/MinGW环境使下使用CMake编译。

  生成Ninja编译文件须添加额外参数：`-DRETROARCH=ON -DSQUIRRELJME_ENABLE_TESTING=OFF`

* <span id="tic80_build"> </span>**TIC-80**

  同时支持使用MSys/MinGW和Visual C++编译。

  + <span id="tic80_msys2_cmake"> </span>MSys2/MinGW环境使下使用CMake编译。

    生成Ninja编译文件须添加额外参数：

    `-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_LIBRETRO=ON -DBUILD_PRO=ON -DBUILD_EDITORS=OFF -DBUILD_PLAYER=OFF -DBUILD_TOUCH_INPUT=ON -DBUILD_SDLGPU=ON -DBUILD_WITH_ALL=ON`

  + <span id="tic80_vc_cmake"> </span>Visual C++环境下使用CMake编译。

    生成Ninja编译文件须添加额外参数：

    `-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_LIBRETRO=ON -DBUILD_PRO=ON -DBUILD_EDITORS=OFF -DBUILD_PLAYER=OFF -DBUILD_TOUCH_INPUT=ON -DBUILD_SDLGPU=ON -DBUILD_WITH_ALL=ON`

- <span id="holani_msys2_cargo"> </span>**Holani**

  使用rust语言编写，在MSys2环境下使用cargo编译。

  编译命令：
  
  ```bash
  cargo build --relase
  ```

  > [!NOTE]
  >
  > librero-holani仓库下只是编译脚本，实际源代码是在https://github.com/LLeny/holani中，编译时会自动下载。编译输出结果在`target/release`目录下，文件名为`halani.dll`
  >

## 四、个人汉化模拟器内核列表

### Aracde 街机模拟器内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| MAME                                                         | [libretro-mame](https://github.com/crazyqk2019/libretro-mame) | MAME多机种模拟器                                             |                |
| MAME 2000                                                    | [libretro-mame2000](https://github.com/crazyqk2019/libretro-mame2000) | 基于2000年版本的MAME (0.37b5)。<br />和iMAME4All/MAME4Droid/MAME 0.37b5兼容。 |                |
| [MAME 2003-Plus](https://docs.libretro.com/library/mame2003_plus/) | [libretro-mame2003_plus](https://github.com/crazyqk2019/libretro-mame2003_plus) | 基于2018年版本的MAME (0.78)。                                |                |
| [MAME 2010](https://docs.libretro.com/library/mame_2010/)    | [libretro-mame2010](https://github.com/crazyqk2019/libretro-mame2010) | 基于2010年版本的MAME (0.139)。                               |                |
| MAME 2015                                                    | [libretro-mame2015](https://github.com/crazyqk2019/libretro-mame2015) | 基于2014年晚期/2015年早期版本的MAME (0.160-ish)。            |                |
| MAME 2016                                                    | [libretro-mame2016](https://github.com/crazyqk2019/libretro-mame2016) | 基于2016年版本的MAME (0.174)。                               |                |
| HBMAME                                                       | [libretro-hbmame](https://github.com/crazyqk2019/libretro-hbmame) | MAME的改版，主要用于运行自制和修改版街机游戏。               |                |
| Final Burn Alpha 2012                                        | [libretro-fbalpha2012](https://github.com/crazyqk2019/libretro-fbalpha2012) | 基于Final Burn Alpha 2012 (0.2.97.24)。                      |                |
| Final Burn Alpha 2012 CPS1                                   | [libretro-fbalpha2012_cps1](https://github.com/crazyqk2019/libretro-fbalpha2012_cps1) | 基于Final Burn Alpha 2012 (0.2.97.24)。<br />单独的Capcom CPS1内核。 |                |
| Final Burn Alpha 2012 CPS2                                   | [libretro-fbalpha2012_cps2](https://github.com/crazyqk2019/libretro-fbalpha2012_cps2) | 基于Final Burn Alpha 2012 (0.2.97.24)。<br />单独的Capcom CPS2内核。 |                |
| Final Burn Alpha 2012 CPS3                                   | [libretro-fbalpha2012_cps3](https://github.com/crazyqk2019/libretro-fbalpha2012_cps3) | 基于Final Burn Alpha 2012 (0.2.97.24)。<br />单独的Capcom CPS3内核。 |                |
| Final Burn Alpha 2012 NeoGeo                                 | [libretro-fbalpha2012_neogeo](https://github.com/crazyqk2019/libretro-fbalpha2012_neogeo) | 基于Final Burn Alpha 2012 (0.2.97.24)。<br />单独的Neo Geo内核。 |                |
| [Final Burn Neo](https://docs.libretro.com/library/fbneo/)   | [libretro-fbneo](https://github.com/crazyqk2019/libretro-fbneo) | FinalBurn和FinalBurn Alpha的后继模拟器。                     |                |
| [SAME_CDI](https://docs.libretro.com/library/same_cdi/)      | [libretro-same_cdi](https://github.com/crazyqk2019/libretro-same_cdi) | 从MAME分支而来，只包含了Philips CD-i的驱动。<br />简化了CD游戏的加载。 |                |

### Nintendo 系列机型内核

**GB 系列**

| 内核名称（官网说明链接）                                    | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ----------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [SameBoy](https://docs.libretro.com/library/sameboy/)       | [libretro-sameboy](https://github.com/crazyqk2019/libretro-sameboy)<br />（分支为`buildbot`） | GB和GBC模拟器。<br />追求极致精确模拟。                      | 2024/04/25     |
| [Gearboy](https://docs.libretro.com/library/gearboy/)       | [libretro-gearboy](https://github.com/crazyqk2019/libretro-gearboy) | GB/GBC模拟器。                                               | 2024/04/25     |
| [TGB Dual](https://docs.libretro.com/library/tgb_dual/)     | [libretro-tgbdual](https://github.com/crazyqk2019/libretro-tgbdual) | GB/GBC模拟器。<br />支持联机对战线。                         | 2024/04/25     |
| [Gambatte](https://docs.libretro.com/library/gambatte/)     | [libretro-gambatte](https://github.com/crazyqk2019/libretro-gambatte) | GB/GBC模拟器（内置大量调色板）。<br />致力于高精度模拟。     | 2025/04/28     |
| [mGBA](https://docs.libretro.com/library/mgba/)             | [libretro-mgba](https://github.com/crazyqk2019/libretro-mgba) | GBA模拟器。<br />设计目标是更快更精确的GBA模拟，同时也支持GB/GBC。 | 2024/04/25     |
| [gpSP](https://docs.libretro.com/library/gpsp/)             | [libretro-gpsp](https://github.com/crazyqk2019/libretro-gpsp) | GBA模拟器。<br />支持动态重编译，最初是为PSP编写的模拟器，为ARM Linux优化。 | 2025/04/25     |
| [Beetle GBA](https://docs.libretro.com/library/beetle_gba/) | [libretro-mednafen_gba](https://github.com/crazyqk2019/libretro-mednafen_gba) | GBA模拟器。<br />Mednafen多机种模拟器中的GBA内核。<br />其自身基于VBA-M。 | 2025/04/25     |
| [Meteor](https://docs.libretro.com/library/meteor/)         | [libretro-meteor](https://github.com/crazyqk2019/libretro-meteor) | GBA模拟器。                                                  | 2025/04/29     |
| [VBA-M](https://docs.libretro.com/library/vba_m/)           | [libretro-vbam](https://github.com/crazyqk2019/libretro-vbam) | GBA模拟器。<br />VisualBoyAdvance的增强版，集成了更多功能和改进，<br />同时也支持GB/GBC/SGB（边框和调色板）。 | 2025/04/25     |
| [VBA Next](https://docs.libretro.com/library/vba_next/)     | [libretro-vba_next](https://github.com/crazyqk2019/libretro-vba_next) | GBA模拟器。<br />基于VBA-M 2011版，融合了一些性能和兼容性增强补丁。 | 2025/04/25     |
| [Beetle VB](https://docs.libretro.com/library/beetle_vb/)   | [libretro-mednafen_vb](https://github.com/crazyqk2019/libretro-mednafen_vb) | VB 模拟器。<br />Mednafen多机种模拟器中的 VB 内核。          | 2025/04/28     |
| [PokeMini](https://docs.libretro.com/library/pokemini/)     | [libretro-pokemini](https://github.com/crazyqk2019/libretro-pokemini) | [Pokémon Mini](https://en.wikipedia.org/wiki/Pokémon_Mini) 掌机模拟器。 | 2025/04/28     |

**FC/NES 系列**

| 内核名称（官网说明链接）                                | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [FCEUmm](https://docs.libretro.com/library/fceumm/)     | [libretro-fceumm](https://github.com/crazyqk2019/libretro-fceumm) | FC模拟器。<br />FCEU Ultra模拟器的mapper修改版，<br />支持大量新的mapper以及未授权游戏的mapper。 | 2025/04/29     |
| [Nestopia](https://docs.libretro.com/library/nestopia/) | [libretro-nestopia](https://github.com/crazyqk2019/libretro-nestopia) | FC模拟器。<br />精确时钟周期模拟的FC模拟器。<br />libretro版本包含了超频功能。 | 2025/04/30     |
| [QuickNES](https://docs.libretro.com/library/quicknes/) | [libretro-quicknes](https://github.com/crazyqk2019/libretro-quicknes) | FC模拟器。                                                   | 2025/04/30     |

**SFC/SNES 系列**

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [bsnes](https://docs.libretro.com/library/bsnes_accuracy/)   | [libretro-bsnes](https://github.com/crazyqk2019/libretro-bsnes) | SFC模拟器。<br />高精度的SFC模拟器。                         |                |
| [bsnes mercury](https://docs.libretro.com/library/bsnes_mercury_accuracy/) | [libretro-bsnes_mercury](https://github.com/crazyqk2019/libretro-bsnes_mercury) | SFC模拟器。<br />bsnes的分支版本，<br />恢复了新版bsnes移除的一些功能，同时提高了一些性能。<br />仍然保持了最大模拟精度，所有影响精度的的选项默认都是关闭的。<br />有accurary/performance/balanced三个不同的编译配置。 |                |
| bsnes 2014                                                   | [libretro-bsnes2014](https://github.com/crazyqk2019/libretro-bsnes2014)<br />（分支为`libretro`) | SFC模拟器。<br />基于bsnes 2014的分支版本。<br />有accurary/performance/balanced三个不同的编译配置。 |                |
| bsnes hd                                                     | [libretro-bsnes_hd](https://github.com/crazyqk2019/libretro-bsnes_hd) | SFC模拟器。<br />bsnes的分支版本，增加了HD视频功能。         |                |
| [bsnes jg](https://docs.libretro.com/library/bsnes-jg/)      | [libretro-bsnes_jg](https://github.com/crazyqk2019/libretro-bsnes_jg) | SFC模拟器。<br />bsnes v115的分支版本，做了一些其他改进。    |                |
| [Snes9x](https://docs.libretro.com/library/snes9x/)          | [libretro-snes9x](https://github.com/crazyqk2019/libretro-snes9x) | SFC模拟器。<br />和最新的Snes9x的主线版本同步。              |                |

**N64 系列**

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------- | -------------- |
| [Mupen64Plus-Next](https://docs.libretro.com/library/mupen64plus/) | [libretro-mupen64plus_next](https://github.com/crazyqk2019/libretro-mupen64plus_next)<br />（分支为`develop`） | N64模拟器。<br />和最新的Mupen64Plus-Next主线版本同步。 |                |
| ParaLLEl N64                                                 | [libretro-parallel_n64](https://github.com/crazyqk2019/libretro-parallel_n64) | N64模拟器。<br />基于Mupen64Plus，做了优化和重写。      |                |

**NGC/Wii 系列**

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明         | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------- | -------------- |
| <span id="dolphin"> </span>[Dolphin](https://docs.libretro.com/library/dolphin/) | [libretro-dolphin](https://github.com/crazyqk2019/libretro-dolphin) | NGC/Wii 模拟器。 |                |

**DS 系列**

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                    | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------- | -------------- |
| [DeSmuME](https://docs.libretro.com/library/desmume/)        | [libretro-desmume](https://github.com/crazyqk2019/libretro-desmume) | NDS模拟器。                 |                |
| <span id="melondsds"> </span>[melonDS DS](https://docs.libretro.com/library/melonds_ds/) | [libretro-melondsds](https://github.com/crazyqk2019/libretro-melondsds)（分支为`main`） | NDS模拟器。<br />支持NDSi。 |                |
| <span id="citra"> </span>[Citra](https://docs.libretro.com/library/citra/) | [libretro-citra](https://github.com/crazyqk2019/libretro-citra) | 3DS模拟器。                 |                |

### Sega 系列机型内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Gearsystem](https://docs.libretro.com/library/gearsystem/)  | [libretro-gearsystem](https://github.com/crazyqk2019/libretro-gearsystem) | MS/GG/SG-100/Othello 机种模拟器。                            |                |
| [SMS Plus GX](https://docs.libretro.com/library/smsplus/)    | [libretro-smsplus](https://github.com/crazyqk2019/libretro-smsplus) | MS/GG模拟器。<br />SMS Plus的增强版本，包含了性能改进和bug修复。 |                |
| [Genesis Plus GX](https://docs.libretro.com/library/genesis_plus_gx/) | [libretro-genesis_plus_gx](https://github.com/crazyqk2019/libretro-genesis_plus_gx) | MS/GG/MD/MDCD/SG-1000/Pico多机种模拟器。<br />Genesis Plus的增强版本，100%兼容上述机型的所有已发行游戏。 |                |
| Genesis Plus Gx Wide                                         | [libretro-genesis_plus_gx_wide](https://github.com/crazyqk2019/libretro-genesis_plus_gx_wide)<br />（分支为`main`） | MS/GG/MD/MDCD/SG-1000/Pico多机种模拟器。<br />Genesis Plus GX的宽屏修改版本。 |                |
| [PicoDrive](https://docs.libretro.com/library/picodrive/)    | [libretro-picodrive](https://github.com/crazyqk2019/libretro-picodrive) | MS/MD/MDCD/32X模拟器。<br />为了基于ARM的手持设备而优化。    |                |
| BlastEm                                                      | [libretro-blastem](https://github.com/crazyqk2019/libretro-blastem)<br />（分支为`libretro`） | MD模拟器。<br />和最新版BlastEm同步，快速和高精度的MD模拟器。 |                |

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Beetle Saturn](https://docs.libretro.com/library/beetle_saturn/) | [libretro-mednafen_saturn](https://github.com/crazyqk2019/libretro-mednafen_saturn) | SS模拟器。<br />Mednafen 多机种模拟器中的 SS 内核。          |                |
| [Kronos](https://docs.libretro.com/library/kronos/)          | [libretro-kronos](https://github.com/crazyqk2019/libretro-kronos)<br />（分支`kronos`） | SS模拟器。<br />[Yabause](https://docs.libretro.com/library/yabause/)的分支版本。<br />使用了着色器渲染，需要 OpenGL 4.3。<br />同时模拟了 SS 的街机版本 ST-V。<br />这是一个是相当活跃的 SS 模拟器项目，<br />同时也是唯一被官方支持的 libretro SS 内核。 |                |

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                             | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------ | -------------- |
| <span id="flycast"> </span>[Flycast](https://docs.libretro.com/library/flycast/) | [libretro-flycast](https://github.com/crazyqk2019/libretro-flycast) | DC/Naomi/Naomi 2/Atomiswave 模拟器。 |                |

### Sony 系列机型内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Beetle PSX](https://docs.libretro.com/library/beetle_psx/)<br />[Beetle PSX HW](https://docs.libretro.com/library/beetle_psx_hw/) | [libretro-mednafen_psx](https://github.com/crazyqk2019/libretro-mednafen_psx) | PS1模拟器。<br />Mednafen多机种模拟器的单独PS1内核。         |                |
| [PCSX ReARMed](https://docs.libretro.com/library/pcsx_rearmed/) | [libretro-pcsx_rearmed](https://github.com/crazyqk2019/libretro-pcsx_rearmed) | PS1模拟器。<br />PCSX Reloaded的分支版本。<br />专门为ARM处理器优化。 |                |
| <span id="swanstation"> </span>SwanStation                   | [libretro-swanstation](https://github.com/crazyqk2019/libretro-swanstation) | PS1模拟器。                                                  |                |
| <span id="pcsx2"> </span>~~[PCSX2](https://docs.libretro.com/library/pcsx2/)~~ | ~~[libretro-pcsx2_old](https://github.com/crazyqk2019/libretro-pcsx2_old)~~ | ~~PS2模拟器。<br />基于PCSX2移植到libretro的版本，<br />很久没有和上游版本同步了。~~ |                |
| <span id="lrps2"> </span>[PCSX2(LRPS2)](https://docs.libretro.com/library/lrps2/) | [libretro-pcsx2](https://github.com/crazyqk2019/libretro-pcsx2)<br />（分支`libretroization`） | PCSX2移植到libretro的重度修改硬分支。                        |                |
| <span id="play"> </span>[Play!](https://docs.libretro.com/library/play/) | [libretro-play](https://github.com/crazyqk2019/libretro-play) | PS2模拟器。                                                  |                |

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| <span id="ppsspp"> </span>[PPSSPP](https://docs.libretro.com/library/ppsspp/) | [libretro-ppsspp](https://github.com/crazyqk2019/libretro-ppsspp) | PSP模拟器。<br />支持[OpenGL](https://docs.libretro.com/library/ppsspp/#opengl), [Vulkan](https://docs.libretro.com/library/ppsspp/#vulkan), 和 [Direct3D 11](https://docs.libretro.com/library/ppsspp/#d3d11)。 |                |

### SNK 系列机型内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Beetle NeoPop](https://docs.libretro.com/library/beetle_neopop/) | [libretro-mednafen_ngp](https://github.com/crazyqk2019/libretro-mednafen_ngp) | NGP/NGPC模拟器。<br />Mednafen多机种模拟器的NGP内核，基于NeoPop模拟器。 |                |
| [RACE](https://docs.libretro.com/library/race/)              | [libretro-race](https://github.com/crazyqk2019/libretro-race) | NGP/NGPC 模拟器。                                            |                |

| 内核名称（官网说明链接） | 汉化仓库地址                                                 | 简要说明         | 汉化时间和版本 |
| ------------------------ | ------------------------------------------------------------ | ---------------- | -------------- |
| NeoCD                    | [libretro-neocd](https://github.com/crazyqk2019/libretro-neocd) | Neo Geo CD模拟器 |                |

### NEC 系列机型内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| Beetle PCE                                                   | [libretro-mednafen_pce](https://github.com/crazyqk2019/libretro-mednafen_pce) | PCE模拟器。<br />Medenafen多机种模拟器的单独PCE内核。<br />比Fast版本更加精确，同时保留了对SuperGrafx的支持。 |                |
| [Beetle PCE Fast](https://docs.libretro.com/library/beetle_pce_fast/) | [libretro-mednafen_pce_fast](https://github.com/crazyqk2019/libretro-mednafen_pce_fast) | PCE模拟器。<br />Medenafen多机种模拟器的单独PCE内核Fast版本。<br />牺牲部分精确性，优化了速度，移除了对SuperGrafx的支持。 |                |
| [Beetle SuperGrafx](https://docs.libretro.com/library/beetle_sgx/) | [libretro-mednafen_supergrafx](https://github.com/crazyqk2019/libretro-mednafen_supergrafx) | PCE模拟器。<br />Medenafen多机种模拟器的单独PCE内核。<br />Fast版本的单独的SuperGrafx内核。 |                |
| [Beetle PC-FX](https://docs.libretro.com/library/beetle_pc_fx/) | [libretro-mednafen_pcfx](https://github.com/crazyqk2019/libretro-mednafen_pcfx) | PC-FX模拟器。<br />Medenafen多机种模拟器的单独PC-FX内核。    |                |
| [Neko Project II Kai](https://docs.libretro.com/library/neko_project_ii_kai/) | [libretro-np2kai](https://github.com/crazyqk2019/libretro-np2kai) | PC-9801系列机型模拟器。                                      |                |
| [QUASI88](https://docs.libretro.com/library/quasi88/)        | [libretro-quasi88](https://github.com/crazyqk2019/libretro-quasi88) | PC-8800系列机型模拟器。                                      |                |

### Microsoft 系列机型内核

| 内核名称（官网说明链接）                        | 汉化仓库地址                                                 | 简要说明                            | 汉化时间和版本 |
| ----------------------------------------------- | ------------------------------------------------------------ | ----------------------------------- | -------------- |
| [fMSX](https://docs.libretro.com/library/fmsx/) | [ibretro-fmsx](https://github.com/crazyqk2019/libretro-fmsx) | MSX/MSX2/MSX2+系列8位计算机模拟器。 |                |

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| DOSBox Core                                                  | [libretro-dosbox_core](https://github.com/crazyqk2019/libretro-dosbox_core)<br />（分支`libretro`） | DOS模拟器。<br />DOSBox的libretro内核，和最新的DOSBox SVN主线版本保持同步。 |                |
| <span id="dosboxpure"> </span>[DOSBox Pure](https://docs.libretro.com/library/dosbox_pure/) | [libretro-dosbox_pure](https://github.com/crazyqk2019/libretro-dosbox_pure)<br />（分支`main`） | DOS模拟器。<br />新的基于DOSBox的libretro内核，目标是简化和易用性。<br />实现了一些高级功能，例如存档、屏幕键盘、<br />高可定制性的控制器设置以及倒带功能。 |                |

###  3DO 机型内核

| 内核名称（官网说明链接）                          | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Opera](https://docs.libretro.com/library/opera/) | [libretro-opera](https://github.com/crazyqk2019/libretro-opera) | 3DO模拟器。<br />开源的、LLE模拟的3DO模拟器。<br />Opera是4DO的一个分支，最初是4DO的一个移植版本，<br />而4DO本身又是FreeDO的一个分支，移植到了libretro上。<br />这个分支/重命名是由于原始的4DO项目处于休眠状态，<br />为了区分该项目的新的开发和关注。 |                |

### Atari 系列机型内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Stella](https://docs.libretro.com/library/stella/)          | [libretro-stella](https://github.com/crazyqk2019/libretro-stella) | Atari 2600模拟器。                                           |                |
| [Atari800](https://docs.libretro.com/library/atari800/)      | [libretro-atari800](https://github.com/crazyqk2019/libretro-atari800) | Atari 8位计算机系统(400, 800, 600 XL, 800XL, 130XE)<br />和Atari 5200游戏机模拟器 |                |
| [ProSystem](https://docs.libretro.com/library/prosystem/)    | [libretro-prosystem](https://github.com/crazyqk2019/libretro-prosystem) | Atari 7800模拟器。                                           |                |
| [Virtual Jaguar](https://docs.libretro.com/library/virtual_jaguar/) | [libretro-virtualjaguar](https://github.com/crazyqk2019/libretro-virtualjaguar) | Atari Jaguar模拟器。                                         |                |
| [Beetle Lynx](https://docs.libretro.com/library/beetle_lynx/) | [libretro-mednafen_lynx](https://github.com/crazyqk2019/libretro-mednafen_lynx) | Atari Lynx模拟器。<br />Mednafen多机种模拟器的单独Lynx内核，<br />其自身是Handy的分支。 |                |
| [Handy](https://docs.libretro.com/library/handy/)            | [libretro-handy](https://github.com/crazyqk2019/libretro-handy) | Atari Lynx模拟器。                                           |                |
| [Holani](https://docs.libretro.com/library/holani/)          | [libretro-holani](https://github.com/crazyqk2019/libretro-holani) | Atari Lynx模拟器。                                           |                |
| [Hatari](https://docs.libretro.com/library/hatari/)          | [libretro-hatari](https://github.com/crazyqk2019/libretro-hatari) | Atari ST/STE/TT/Falcon模拟器。                               |                |

### Commodore 系列机型内核

| 内核名称（官网说明链接）                        | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ----------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [VICE](https://docs.libretro.com/library/vice/) | [libretro-vice](https://github.com/crazyqk2019/libretro-vice) | Commodore 8位系列计算机模拟器。<br />支持C64、C64DTV、C128、VIC20、几乎所有的PET型号、<br />PLUS4和CBM-II（又称C610/C510）以及带有CMD SuperCPU扩展的C64。 |                |
| [PUAE](https://docs.libretro.com/library/puae/) | [libretro-uae](https://github.com/crazyqk2019/libretro-uae)  | Commodore Amiga系列计算机/游戏机模拟器。<br />Commodore Amiga是Commodore收购Amiga公司后，<br />于20世纪80年代起推出的系列机型，<br />定位多媒体个人电脑，性能远超同期产品（如Macintosh）。 |                |

### Amstrad 系列机型内核

| 内核名称（官网说明链接）                                  | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| --------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Caprice32](https://docs.libretro.com/library/caprice32/) | [libretro-cap32](https://github.com/crazyqk2019/libretro-cap32) | Amstrad CPC 8位家用系列计算机模拟器。<br />Amstrad CPC系列由英国Amstrad公司于1984年起推出，<br />定位为廉价家用电脑，直接对抗Commodore 64和Sinclair ZX Spectrum。 |                |
| [CrocoDS](https://docs.libretro.com/library/crocods/)     | [libretro-crocods](https://github.com/crazyqk2019/libretro-crocods) | Amstrad CPC 8位家用系列计算机模拟器。<br />基于Win-CPC。CrocoDS最初是NDS编写的模拟器。 |                |

### Sharp 系列机型内核

| 内核名称（官网说明链接）                          | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| Sharp X1                                          | [libretro-x1](https://github.com/crazyqk2019/libretro-x1)    | Sharp X1模拟器。<br />1982年由夏普（Sharp）推出，是日本8位元电脑系列，<br />兼具家用电脑和游戏平台功能。<br />定位为与NEC PC-8801、富士通FM-7竞争，<br />主打高性价比和图形性能，后期型号支持游戏开发。 |                |
| [PX68k](https://docs.libretro.com/library/px68k/) | [libretro-px68k](https://github.com/crazyqk2019/libretro-px68k) | Sharp X68000模拟器。<br />1987年由夏普（Sharp）推出，定位为高性能16位个人电脑，<br />主要面向专业用户和游戏开发者。<br />定位为与NEC PC-9801、富士通FM TOWNS竞争。 |                |

### Sinclair 系列机型内核

| 内核名称（官网说明链接）                             | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ---------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [ZX81](https://docs.libretro.com/library/eightyone/) | [libretro-81](https://github.com/crazyqk2019/libretro-81)    | Sinclair ZX81模拟器。<br />Sinclair ZX81 1981年由英国Sinclair Research推出，<br />定位家庭与教育市场，作为ZX80的升级版，主打低成本编程学习。 |                |
| [Fuse](https://docs.libretro.com/library/fuse/)      | [libretro-fuse](https://github.com/crazyqk2019/libretro-fuse) | Sinclair ZX Spectrum模拟器。<br />Sinclair ZX Spectrum 1982年由英国Sinclair Research推出，<br />前身代号"ZX81 Colour/ZX82"，最终命名Spectrum以强调其彩色显示功能。<br />定位家庭娱乐与编程学习。 |                |

### 多机种模拟器内核

| 内核名称（官网说明链接）                                | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [blueMSX](https://docs.libretro.com/library/bluemsx/)   | [libretro-bluemsx](https://github.com/crazyqk2019/libretro-bluemsx) | MSX/SVI/ColecoVision/Sega SG-1000模拟器。                    |                |
| [ep128emu](https://docs.libretro.com/library/ep128emu/) | [libretro-ep128emu_core](https://github.com/crazyqk2019/libretro-ep128emu_core)<br />（分支为`core`） | Z80系列家用计算机模拟器。<br />支持Enterprise 64/128, Videoton TVC, <br />Amstrad CPC和ZX Spectrum。 |                |
| [GW](https://docs.libretro.com/library/gw/)             | [libretro-gw](https://github.com/crazyqk2019/libretro-gw)    | 多种早期游戏掌机的模拟器。<br />包括任天堂Game & Watch系列，<br />Mattel、VTech、Coleco、Elektronika、Bandai等公司推出的掌机。 |                |

### 其他模拟器内核

| 内核名称（官网说明链接）                                     | 汉化仓库地址                                                 | 简要说明                                                     | 汉化时间和版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| [Beetle Cygne](https://docs.libretro.com/library/beetle_cygne/) | [libretro-mednafen_wswan](https://github.com/crazyqk2019/libretro-mednafen_wswan) | 万代WS/WSC模拟器。<br />Mednafen多机种模拟器的单独WS内核，<br />其本身是Cygen的分支。 |                |
| [SameDuck](https://docs.libretro.com/library/sameduck/)      | [libretro-sameduck](https://github.com/crazyqk2019/libretro-sameduck)<br />（分支为`SameDuck-libretro`） | Mega Duck模拟器。<br />是20世纪90年代推出的一款掌机（南美市场叫Cougar Boy），<br />主要作为任天堂Game Boy的竞争对手。 |                |
| Potator                                                      | [libretro-potator](https://github.com/crazyqk2019/libretro-potator) | Watara Supervision（威特霸）掌机模拟器。<br />Watara Supervision是一款1992年由香港Watara公司推出的掌上游戏机，<br />主要作为任天堂Game Boy的廉价竞品面向市场。 |                |
| [bk](https://docs.libretro.com/library/bk/)                  | [libretro-bk](https://github.com/crazyqk2019/libretro-bk)    | BK-0010/0011/Terak 8510a模拟器。<br />- BK-0010/0011是由苏联电子工业部1985年推出的8位计算机，<br />用于教育和小型办公，克隆美国DEC PDP-11架构；<br />- Terak 8510a是1977年由美国Terak公司推出的图形工作站，<br />早期结合字符与矢量图形的混合系统，用于CAD和教育。 |                |
| [JAXE](https://docs.libretro.com/library/jaxe/)              | [libretro-jaxe](https://github.com/crazyqk2019/libretro-jaxe)<br />（分支为`main`） | XO-CHIP/S-CHIP/CHIP-8模拟器。<br />CHIP-8及其衍生系统（XO-CHIP/S-CHIP）<br />是1970年代为COSMAC VIP和Telmac 1800（8位微机）<br />设计的解释型编程语言/虚拟机，目的是简化游戏开发。 |                |
| [FreeIntv](https://docs.libretro.com/library/freeintv/)      | [libretro-freeintv](https://github.com/crazyqk2019/libretro-freeintv) | Mattel Intellivision模拟器。 <br />此模拟器设计为能兼容SNES手柄。<br />Mattel Intellivision 1979年由玩具巨头美泰（Mattel）推出，<br />定位为高端家庭游戏机，直接挑战雅达利2600（Atari VCS）。 |                |
| [GearColeco](https://docs.libretro.com/library/gearcoleco/)  | [libretro-gearcoleco](https://github.com/crazyqk2019/libretro-gearcoleco) | ColecoVision模拟器。<br />ColecoVision 1982年由美国Coleco公司推出，<br />定位为高性能家庭游戏机，直接挑战雅达利2600和Intellivision。 |                |
| [Numero](https://docs.libretro.com/library/numero/)          | [libretro-numero](https://github.com/crazyqk2019/libretro-numero) | TI-83图形计算器模拟器。<br />TI-83是由德州仪器（Texas Instruments）推出的图形计算器，<br />主打中学至大学数学/科学教育。 |                |
| [O2EM](https://docs.libretro.com/library/o2em/)              | [libretro-o2em](https://github.com/crazyqk2019/libretro-o2em) | Magnavox Odyssey2/Philips Videopac+模拟器。<br />Odyssey2（欧版叫Videopac/Jopac）是上世纪70年代末推出的一款游戏机。 |                |
| Oberon                                                       | [libretro-oberon](https://github.com/crazyqk2019/libretro-oberon) | Oberon RISC系统模拟器。<br />Oberon RISC系统由瑞士苏黎世联邦理工学院的<br />Niklaus Wirth（Pascal语言之父）与Jürg Gutknecht教授<br />于1980年代设计。 |                |
| [ScummVM](https://docs.libretro.com/library/scummvm/)        | [libretro-scummvm](https://github.com/crazyqk2019/libretro-scummvm) | ScummVM是一款开源的跨平台游戏引擎，<br />专门用于运行经典的点击式冒险游戏（Point-and-Click Adventure Games）。<br />它支持众多老游戏，<br />特别是基于SCUMM（Script Creation Utility for Maniac Mansion）<br />引擎开发的经典作品。<br />它通过读取老游戏的数据包，替换原有可执行文件来运行。 |                |
| <span id="squirreljme"> </span>SquirrelJME                   | [libretro-squirreljme](https://github.com/crazyqk2019/libretro-squirreljme)<br />（分为`trunk`） | Java ME 8虚拟机。<br />它的最终目标是达到和Java ME标准99.9%的兼容性。 |                |
| [Theodore](https://docs.libretro.com/library/theodore/)      | [libretro-theodore](https://github.com/crazyqk2019/libretro-theodore) | Thomson MO/TO系统模拟器。<br />MO/TO是20世纪80年代法国Thomson-Brandt公司推出的系列计算机。 |                |
| <span id="tic80"> </span>[TIC-80](https://docs.libretro.com/library/tic80/) | [libretro-tic80](https://github.com/crazyqk2019/libretro-tic80)<br />（分支为`main`） | TIC-80模拟器。<br />TIC-80是一款免费开源的幻想计算机（Fantasy Computer），<br />专为制作、运行和分享复古风格的小游戏而设计。<br />它提供了一套完整的开发工具，适合独立开发者、教育用途或复古游戏爱好者。 |                |
| [MicroW8](https://docs.libretro.com/library/microw8/)        | [libretro-uw8](https://github.com/crazyqk2019/libretro-uw8)<br />（分支为`main`） | MicroW8模拟器。<br />MicroW8是一款基于WebAssembly的轻量级、模块化的8位计算机模拟器，<br />专为复古计算爱好者和开发者设计。<br />它允许用户模拟经典的8位计算机架构（如 6502、Z80 等），<br />并支持自定义硬件扩展和编程实验。 |                |
| [Uzem](https://docs.libretro.com/library/uzem/)              | [libretro-uzem](https://github.com/crazyqk2019/libretro-uzem) | Uzebox模拟器。<br />Uzem是Uzebox的官方模拟器。<br />Uzebox是一款开源复古游戏主机，基于AVR单片机设计，<br />以极简硬件实现完整的游戏机功能。 |                |
| [vecx](https://docs.libretro.com/library/vecx/)              | [libretro-vecx](https://github.com/crazyqk2019/libretro-vecx) | GCE Vectrex模拟器。<br />Vectrex是20世纪80年代初期推出的一款自带矢量显示器的家用机，<br />采用黑白矢量图形（非传统光栅图形），通过彩色滤镜增强画面。 |                |

## 五、项目目录和文件说明

### scripts下目录主要工具脚本说明

| 文件名                       | 说明                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| setup_msys2_from_scratch.cmd | 从零开始自动安装和设置msys2，默认安装ucrt64编译环境。        |
| msys2shell.cmd               | 进入不同的msys2 shell环境，运行参数：<br />`msys2shell.cmd [/m msys2_home_dir] [/e msys2|mingw64|ucrt64|clang64] [script] [script params]` |
| msys2shell.ini               | msys2shell.cmd的配置文件，可以把msys2目录和要启动的编译环境写入配置文件，<br />运行msys2shell.cmd时可以不用输入参数。 |
| vc64shell.cmd                | 进入VC2022 64位编译环境，无参数直接运行。                    |
| inst_pkgs.sh                 | 安装msys2开发环境所需的包和库。运行参数：<br />`./inst_pkgs.sh <mingw64|ucrt64|clang64>` |
| inst_capsimage.sh            | MingGW下自动编译安装capsimage的脚本。                        |
| update_pkgs.sh               | 更新msys2。                                                  |
| clone_ra.sh                  | 克隆RetroArch汉化库源代码到retrorch目录，并把原始RA仓库添加为上游仓库。 |
| clone_ra_orig.sh             | 克隆原始RetroArch源代码到retroarch_orig目录。                |
| clone_cores.sh               | 克隆汉化RA模拟器内核源码到cores目录下，并把原始内核仓库添加为上游仓库。 |
| build_ra.sh                  | 编译RetroArch，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| build_ra_filters.sh          | 编译RetroAch的音视频滤镜，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| build_cores.sh               | 编译RA模拟器内核。运行参数：`./build_cores.sh [-noclean] all|core1 [core2]...`<br />-noclean：编译前不要进行清理。<br />all: 编译所有内核。<br />core1 core2: 编译指定内核，不带参数运行脚本可以查看可用内核。<br />编译完成的内核文件为拷贝到`cores\dists`目录下 |
| build_cores.cmd              | 编译需要在VS2022下编译的RA模拟器内核，运行参数：<br />`build_cores.cmd [/noclean] all | core1 [core2]...` |
| dist_ra.sh                   | 创建RetroArch分发目录retroarch_dist，请在retroarch_orig或者retrorch源代码根目录下运行。 |
| dist_cores.sh                | 分发RA模拟器内核到retroarch_dist目录，运行参数：`./dist_cores.sh [all|core1.dll core2.dll...]`<br />此脚本在默认内核编译输出目录`cores\dists`下寻找内核。 |

### libs 目录 - 编译需要的一些第三方库

| 文件名                         | 说明                                         |
| ------------------------------ | -------------------------------------------- |
| capsimg_source_windows.7z      | capsimage 5.1 源代码Windows版                |
| capsimg_source_linux_macosx.7z | capsimage 5.1 源代码Linux版                  |
| x86_64-linux-gnu-capsimage.7z  | capsimage 4.2 二进制包Linux版，包含4.2头文件 |

### tools 目录 - 需要用到的一些第三方工具

| 文件名      | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| vswhere.exe | 用于查找VS安装信息。来自于<https://github.com/microsoft/vswhere> |
| python.7z   | Python3 嵌入版，解压后用于VS2022编译                         |

## 六、杂项问题

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

### 处理 git 换行符问题

```bash
# 拉取和提交时都保持原样，不要自动转换换行符
git config --system core.autocrlf false
git config --global core.autocrlf false
# 提交时检查换行符，不许提交包含混合换行符的文件
git config --system core.safecrlf true
git config --global core.safecrlf true
```

### clone 代码出现 SSL 错误的问题

使用用 SteamCommunity 302 工具解决github访问问题时，用git命令行clone代码可能会出现以下错误：

```bash
SSL certificate problem: unable to get local issuer certificate
```

配置 git 使用 Windows 自带的 Schannel 进行证书验证可解决。

注意：该方法只对VC环境下的git有效，MSys2环境下的git只支持OpenSSL作为SSL后端，无法绕过这个错误。

```bash
git config --system http.sslBackend schannel
```

### 子模块仓库地址变更问题

和上游仓库合并时子模块地址发生变更，需要执行`git submodule sync --recursive`命令来同步变更本地仓库配置。



---

[官方Windows编译指导]: https://docs.libretro.com/development/retroarch/compilation/windows/

[官方最新编译和资源下载]: https://buildbot.libretro.com/




# Windows下RetroArch编译环境


## 目录说明
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




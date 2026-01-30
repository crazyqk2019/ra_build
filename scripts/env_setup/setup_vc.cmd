@ECHO OFF
SETLOCAL

where wget 1>NUL 2>&1 || (ECHO 未找到 wget，请先安装 wget [winget install wget]。& GOTO :err)

SET "git_download_url=https://github.com/git-for-windows/git/releases/download/v2.52.0.windows.1"
SET "git_file=MinGit-2.52.0-busybox-64-bit.zip"
SET "cmake_download_url=https://github.com/Kitware/CMake/releases/download/v4.2.3"
SET "cmake_file=cmake-4.2.3-windows-x86_64.zip"

SET "_7za_exe_=..\tools\7za.exe"
SET "python_file=tools\python.7z"
SET "_PortableBuildTools_exe_=tools\PortableBuildTools.exe"


PUSHD "%~dp0"

PUSHD ..
SET "INST_DEST=%CD%\vc_env"
POPD

ECHO 安装 VC 编译工具……
IF NOT EXIST "%INST_DEST%\vc_build_tools" (
    %_PortableBuildTools_exe_% accept_license path="%INST_DEST%\vc_build_tools" || (CHCP 963>NUL & ECHO 安装 VC 编译工具出错！& GOTO :err)
)
CHCP 936>NUL
ECHO 安装 VC 编译工具完成。
ECHO.

IF NOT EXIST "temp\%cmake_file%" (
    ECHO 下载 CMake ……
    wget -O "temp\%cmake_file%" "%cmake_download_url%\%cmake_file%" || (ECHO 下载 CMake 出错！& GOTO :err)
    ECHO 下载完成。
)
ECHO 解压 CMake ……
%_7za_exe_% x -y -bso0 -o"%INST_DEST%" temp\%cmake_file% || (ECHO 解压 CMake 出错！& GOTO :err)
IF EXIST "%INST_DEST%\cmake" (RD /S /Q "%INST_DEST%\cmake")
MOVE /Y "%INST_DEST%\%cmake_file:~0,-4%" "%INST_DEST%\cmake"
ECHO 解压 CMake 完成。
ECHO.

IF NOT EXIST "temp\%git_file%" (
    ECHO 下载 Git for Windows ……
    wget -O "temp\%git_file%" "%git_download_url%\%git_file%" || (ECHO 下载 Git for Windows 出错！& GOTO :err)
    ECHO 下载完成。
)
ECHO 解压 Git for Windows ……
%_7za_exe_% x -y -bso0 -o"%INST_DEST%\git" "temp\%git_file%" || (ECHO 解压 Git for Windows 出错！& GOTO :err)
ECHO 解压 Git for Windows 完成。
ECHO 初始化 Git ……
PUSHD "%INST_DEST%\git\cmd"
git config --global core.autocrlf false
git config --global core.safecrlf true
git config --global http.sslBackend schannel
git config --system core.autocrlf false
git config --system core.safecrlf true
git config --system http.sslBackend schannel
POPD
ECHO 初始化 Git 完成。
ECHO.

ECHO 解压 Python ……
%_7za_exe_% x -y -bso0 -o"%INST_DEST%" "%python_file%" || (ECHO 解压 Python 失败！& GOTO :err)
ECHO 解压 Python 完成。
ECHO.

ECHO 全部工作完成！
POPD & EXIT /B 0

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)
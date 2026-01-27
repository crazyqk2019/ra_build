@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

ECHO 下载msys2安装包...
IF EXIST msys2-x86_64-latest.sfx.exe (
    ECHO "msys2-x86_64-latest.sfx.exe" 文件已存在，跳过下载。
) ELSE (
    curl https://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe -o msys2-x86_64-latest.sfx.exe || GOTO :error
    ECHO 下载完成。& ECHO.
)

ECHO 解压msys2安装包...
CD ..
SET MSYS2_DIR=%CD%
CD "%~dp0"
SET /P MSYS2_DIR="输入msys2安装路径(默认路径为%MSYS2_DIR%)："
IF EXIST "%MSYS2_DIR%\msys64" (
    ECHO 目标目录已存在："%MSYS2_DIR%\msys64"，跳过解压。
) ELSE （
    IF NOT EXIST %MSYS2_DIR% (MKDIR %MSYS2_DIR% || (ECHO 创建目录出错！& GOTO :error))
    msys2-x86_64-latest.sfx.exe -o"%MSYS2_DIR%" || GOTO :error
    ECHO 解压完成。& ECHO.
)

ECHO 更新msys2系统...
SET "msys2_shell_cmd=%MSYS2_DIR%\msys64\msys2_shell.cmd -no-start -full-path -defterm -msys2 -where "%CD%"" 
START /WAIT CMD /C %msys2_shell_cmd% update_pkgs.sh
IF ERRORLEVEL 2 (ECHO 更新msys2系统出错！& GOTO :error)
START /WAIT CMD /C %msys2_shell_cmd% update_pkgs.sh
IF NOT %ERRORLEVEL% == 0 (ECHO 更新msys2系统出错！& GOTO :error)
ECHO 更新msys2系统完成。& ECHO.

SET "msys2_shell_cmd=%MSYS2_DIR%\msys64\msys2_shell.cmd -no-start -full-path -defterm -ucrt64 -where "%CD%"" 

ECHO 安装程序和库...
CALL %msys2_shell_cmd% inst_pkgs.sh ucrt64
IF NOT %ERRORLEVEL% == 0 (ECHO 程序和库安装出错！& GOTO :error)
ECHO 程序和库安装完成。& ECHO.

ECHO 安装capsimage...
CALL %msys2_shell_cmd% inst_capsimage.sh
IF NOT %ERRORLEVEL% == 0 (ECHO capsimage安装出错！& GOTO :error)
ECHO capsimage安装完成。& ECHO.

ECHO 将当前msys2安装目录写入msys2shell.ini配置文件...
ECHO MSYS2_HOME=%MSYS2_DIR%\msys64>msys2shell.ini
ECHO COMPILER_ENV=ucrt64>>msys2shell.ini
ECHO 写入完成。& ECHO.

ECHO 全部工作完成！
POPD & EXIT /B %ERRORLEVEL%

:error
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)
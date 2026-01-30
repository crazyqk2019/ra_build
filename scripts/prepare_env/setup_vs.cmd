@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

PUSHD ..\..\
SET "INST_DEST=%CD%"
POPD

CALL mingw_dev_env\scripts\setup_msys2.cmd "%INST_DEST%" || GOTO :err
CALL mingw_dev_env\scripts\setup_toolchain.cmd "%INST_DEST%\msys64" ucrt64 || GOTO :err

SET "msys2_shell_cmd=%INST_DEST%\msys64\msys2_shell.cmd -no-start -defterm -ucrt64 -where "%CD%"" 

ECHO 安装工具和库...
CALL %msys2_shell_cmd% inst_pkgs.sh ucrt64
IF NOT %ERRORLEVEL% == 0 (ECHO 程序和库安装出错！& GOTO :err)
ECHO 工具和库安装完成。& ECHO.

ECHO 编译安装capsimage库...
CALL %msys2_shell_cmd% inst_capsimage.sh
IF NOT %ERRORLEVEL% == 0 (ECHO capsimage安装出错！& GOTO :err)
ECHO capsimage安装完成。& ECHO.

ECHO 将当前msys2安装目录写入msys2shell.ini配置文件...
ECHO MSYS2_HOME=%INST_DEST%\msys64>..\msys2shell.ini
ECHO COMPILER_ENV=ucrt64>>..\msys2shell.ini
ECHO 写入完成。& ECHO.

ECHO 全部工作完成！
POPD & EXIT /B %ERRORLEVEL%

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)
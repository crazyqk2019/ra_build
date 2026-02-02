@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

SET "LIBSMB2_SRC_PKG=%CD%\libs\libsmb2-libsmb2-6.2.7z"

PUSHD ..
SET "_7za_exe_=%CD%\tools\7za.exe"
SET "INSTALL_PREFIX=%CD%\msys2_env\msys64\ucrt64"
SET "VC_BUILD_TOOLS=%CD%\vc_env\vc_build_tools\devcmd.bat"
POPD

REM IF NOT EXIST "%VC_BUILD_TOOLS%" (ECHO 请先安装VC编译环境。& GOTO :err)
REM CALL "%VC_BUILD_TOOLS%"

IF NOT EXIST temp MD temp || (ECHO 创建临时目录出错！& GOTO :err)
%_7za_exe_% x -y -bso0 -o"temp" "%LIBSMB2_SRC_PKG%" || (ECHO 解压 libsmb2 源代码出错！& GOTO :err)
FOR /F "tokens=* delims=" %%# IN ("%LIBSMB2_SRC_PKG%") DO (SET "LIBSMB2_SRC_DIR=%%~n#")

ECHO 编译 libsmb2 ……
CD "temp\%LIBSMB2_SRC_DIR%"
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -G Ninja -B vc_build --install-prefix "%INSTALL_PREFIX%" || (ECHO 创建 libsmb2 编译配置文件出错！& GOTO :err)
ECHO.
cmake --build vc_build --config Release -j || (ECHO 编译 libsmb2 出错！& GOTO :err)
ECHO.
ECHO 安装 libsmb2 ……
cmake --install vc_build || (ECHO 安装 libsmb2 出错！& GOTO :err)
ECHO.
ECHO 修正 libsmb2.pc ……
SET "libsmb2.pc=%INSTALL_PREFIX%\lib\pkgconfig\libsmb2.pc"
PowerShell -Command "& {((Get-Content -LiteralPath '%libsmb2.pc%' -Raw) -replace '(?i)%INSTALL_PREFIX:\=/%','/ucrt64') | Set-Content -LiteralPath '%libsmb2.pc%' -NoNewline}"
ECHO 安装 libsmb2 完成。
GOTO :end

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

:end
POPD & EXIT /B 0
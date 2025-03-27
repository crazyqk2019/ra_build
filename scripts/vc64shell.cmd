@ECHO OFF
REM SETLOCAL

PUSHD "%~dp0"

CD ..\tools
SET PATH=%CD%\python;%PATH%

SET "VCVARS64_BAT="
FOR /F "tokens=* delims=" %%# IN ('..\tools\vswhere.exe -latest -property installationPath') DO SET "VCVARS64_BAT=%%~#\VC\Auxiliary\Build\vcvars64.bat"
IF NOT EXIST "%VCVARS64_BAT%" (ECHO 未找到可用的VC安装！&& GOTO :err)
CALL "%VCVARS64_BAT%"

:end
POPD
EXIT /B 0

:err
POPD
EXIT /B 1
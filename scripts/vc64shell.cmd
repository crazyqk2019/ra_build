@ECHO OFF
REM SETLOCAL

PUSHD "%~dp0"

CD ..\tools
SET PATH=%CD%\python;%PATH%

SET "VCVARS64_BAT="
FOR /F "tokens=* delims=" %%# IN ('..\tools\vswhere.exe -latest -property installationPath') DO SET "VCVARS64_BAT=%%~#\VC\Auxiliary\Build\vcvars64.bat"
IF NOT EXIST "%VCVARS64_BAT%" (ECHO δ�ҵ����õ�VC��װ��&& GOTO :err)
CALL "%VCVARS64_BAT%"

:end
POPD
EXIT /B 0

:err
POPD
EXIT /B 1
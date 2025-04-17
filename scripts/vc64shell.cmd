@ECHO OFF
SETLOCAL

PUSHD "%~dp0"
CD ..\tools
SET PATH=%CD%\python;%PATH%
POPD

PUSHD "%~dp0"
SET "VCVARS64_BAT="
FOR /F "tokens=* delims=" %%# IN ('..\tools\vswhere.exe -latest -property installationPath') DO SET "VCVARS64_BAT=%%~#\VC\Auxiliary\Build\vcvars64.bat"
IF NOT EXIST "%VCVARS64_BAT%" (ECHO δ�ҵ����õ�VC��װ��&& GOTO :err)
CMD /K "%VCVARS64_BAT%"

:end
POPD & EXIT /B %ERRORLEVEL%

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

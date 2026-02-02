@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

SET "VC_ENV_PATH=%CD%\vc_env"
SET "PATH=%VC_ENV_PATH%\cmake\bin;%VC_ENV_PATH%\git\cmd;%VC_ENV_PATH%\ninja;%VC_ENV_PATH%\ninja\vcxproj2cmake-win-x64;%VC_ENV_PATH%\python;%PATH%"

CMD /K "%VC_ENV_PATH%\vc_build_tools\devcmd.bat"

GOTO :end

SET "VCVARS64_BAT="
FOR /F "tokens=* delims=" %%# IN ('.\tools\vswhere.exe -latest -property installationPath') DO SET "VCVARS64_BAT=%%~#\VC\Auxiliary\Build\vcvars64.bat"
IF NOT EXIST "%VCVARS64_BAT%" (ECHO 未找到可用的VC安装！&& GOTO :err)
CMD /K "%VCVARS64_BAT%"

:end
POPD & EXIT /B %ERRORLEVEL%

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

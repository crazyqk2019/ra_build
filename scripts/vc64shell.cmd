@ECHO OFF
SETLOCAL

PUSHD "%~dp0"
SET "PATH=%CD%\cmake\bin;%CD%\MinGit\cmd\;%CD%\python;%PATH%"


git config --global core.autocrlf false
git config --global core.safecrlf true
git config --global http.sslBackend schannel
git config --system core.autocrlf false
git config --system core.safecrlf true
git config --system http.sslBackend schannel

CMD /K C:\BuildTools\devcmd.bat
GOTO :end

SET "VCVARS64_BAT="
FOR /F "tokens=* delims=" %%# IN ('.\tools\vswhere.exe -latest -property installationPath') DO SET "VCVARS64_BAT=%%~#\VC\Auxiliary\Build\vcvars64.bat"
IF NOT EXIST "%VCVARS64_BAT%" (ECHO 未找到可用的VC安装！&& GOTO :err)
CMD /K "%VCVARS64_BAT%"

:end
POPD & EXIT /B %ERRORLEVEL%

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

@ECHO OFF
SETLOCAL

IF NOT DEFINED MSYS2_HOME SET "MSYS2_HOME=%~1"
PUSHD "%MSYS2_HOME%"
SET "MSYS2_HOME=%CD%"
POPD
IF NOT EXIST "%MSYS2_HOME%\msys2_shell.cmd" (ECHO msys2_shell.cmd not found! & GOTO :EOF)

%MSYS2_HOME%\msys2_shell.cmd -no-start -full-path -defterm -ucrt64 -where "%CD%"
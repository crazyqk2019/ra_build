@ECHO OFF
SETLOCAL

FOR /F "eol=# usebackq tokens=1,* delims== " %%A IN ("%~dn0.ini") do (SET "%%A=%%~B")

IF NOT "%~1" == "" (SET "MSYS2_HOME=%~1")
IF NOT "%~2" == "" (SET "COMPILER_ENV=%~2")

IF NOT DEFINED MSYS2_HOME (SET /P MSYS2_HOME="MSYS2 home directory?: ")
IF NOT DEFINED MSYS2_HOME  GOTO :print_usage
IF NOT EXIST "%MSYS2_HOME%" GOTO :print_usage
PUSHD "%MSYS2_HOME%" || GOTO :print_usage
SET "MSYS2_HOME=%CD%"
POPD
IF NOT EXIST "%MSYS2_HOME%\msys2_shell.cmd" (ECHO msys2_shell.cmd not found! & GOTO :print_usage)

IF NOT DEFINED COMPILER_ENV (SET /P COMPILER_ENV="Compiler environment? [msys2]|mingw64|ucrt64|clang64: ")
IF NOT DEFINED COMPILER_ENV SET "COMPILER_ENV=msys2"
ECHO msys2 mingw64 ucrt64 clang64 | findstr /i "\<%COMPILER_ENV%\>" >NUL
IF %ERRORLEVEL% NEQ 0 GOTO :print_usage

CMD /C ""%MSYS2_HOME%\msys2_shell.cmd" -no-start -full-path -defterm -%COMPILER_ENV% -where "%CD%""
EXIT /B %ERRORLEVEL%

:print_usage
ECHO 参数错误！
ECHO 使用方法：
ECHO msys2shell.cmd ^msys2_home_dir^ [msys2]^|mingw64^|ucrt64^|clang64
PAUSE
EXIT /B 1
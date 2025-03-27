@ECHO OFF
SETLOCAL

SET "MSYS2_HOME=%~1"
IF NOT DEFINED MSYS2_HOME GOTO :print_usage
IF NOT EXIST "%MSYS2_HOME%" GOTO :print_usage
PUSHD "%MSYS2_HOME%" || GOTO :print_usage
SET "MSYS2_HOME=%CD%"
POPD
IF NOT EXIST "%MSYS2_HOME%\msys2_shell.cmd" (ECHO msys2_shell.cmd not found! & GOTO :print_usage)

SET "COMPILER_ENV=%~2"
IF DEFINED COMPILER_ENV (ECHO mingw64 ucrt64 clang64 | findstr /i "\<%COMPILER_ENV%\>" >NUL)
IF %ERRORLEVEL% NEQ 0 GOTO :print_usage
IF NOT DEFINED COMPILER_ENV SET "COMPILER_ENV=msys2"

"%MSYS2_HOME%\msys2_shell.cmd" -no-start -full-path -defterm -%COMPILER_ENV% -where "%CD%"
EXIT /B %ERRORLEVEL%

:print_usage
ECHO 参数错误！
ECHO 使用方法：
ECHO msys2shell.cmd ^<msys2 home dir^> [mingw64^|ucrt64^|clang64]
EXIT /B 1
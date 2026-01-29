@ECHO OFF
SETLOCAL

FOR /F "eol=# usebackq tokens=1,* delims== " %%A IN ("%~dn0.ini") do (SET "%%A=%%~B")

SET "SCRIPT_FILE=" & SET "SCRIPT_PARAMS="
:parseParamsBegin
IF "%~1" == "" GOTO :parseParamsEnd
SET "_param_=%~1"
IF NOT "%_param_:~0,1%" == "/" (
    IF NOT DEFINED SCRIPT_FILE (SET "SCRIPT_FILE=%~1") ELSE (CALL :addScriptParams "%~1")
    SHIFT & GOTO :parseParamsBegin
)
IF /I "%_param_%" == "/M" (
    IF "%~2" == "" GOTO :showUsage
    SET "MSYS2_HOME=%~2" & SHIFT
) ELSE IF /I "%_param_%" == "/E" (
    IF "%~2" == "" GOTO :showUsage
    ECHO msys2 mingw64 ucrt64 clang64 | findstr /i "\<%~2\>" >NUL || GOTO :showUsage
    SET "COMPILER_ENV=%~2" & SHIFT
) ELSE (GOTO :showUsage)
SHIFT & GOTO :parseParamsBegin
:parseParamsEnd

IF NOT DEFINED MSYS2_HOME (SET /P MSYS2_HOME="MSYS2 home directory?: ")
IF NOT DEFINED MSYS2_HOME  GOTO :showUsage
IF NOT EXIST "%MSYS2_HOME%" (ECHO 目录不存在："%MSYS2_HOME%" & GOTO :error)
PUSHD "%MSYS2_HOME%" || GOTO :showUsage
SET "MSYS2_HOME=%CD%"
POPD
IF NOT EXIST "%MSYS2_HOME%\msys2_shell.cmd" (ECHO msys2_shell.cmd not found! & GOTO :showUsage)

IF NOT DEFINED COMPILER_ENV (SET /P COMPILER_ENV="Compiler environment? [msys2]|mingw64|ucrt64|clang64: ")
IF NOT DEFINED COMPILER_ENV SET "COMPILER_ENV=msys2"
ECHO msys2 mingw64 ucrt64 clang64 | findstr /i "\<%COMPILER_ENV%\>" >NUL
IF NOT %ERRORLEVEL% == 0 GOTO :showUsage

SET "msys2_shell_cmd=%MSYS2_HOME%\msys2_shell.cmd -no-start -defterm -%COMPILER_ENV% -where "%CD%""
IF DEFINED SCRIPT_FILE (SET "msys2_shell_cmd=%msys2_shell_cmd% "%SCRIPT_FILE%"")
IF DEFINED SCRIPT_PARAMS (SET "msys2_shell_cmd=%msys2_shell_cmd% %SCRIPT_PARAMS%")
REM ECHO msys2_shell_cmd=[%msys2_shell_cmd%]
CMD /C %msys2_shell_cmd%
ECHO ERRORLEVEL=%ERRORLEVEL%
EXIT /B %ERRORLEVEL%

:addScriptParams
IF NOT DEFINED SCRIPT_PARAMS (SET "SCRIPT_PARAMS="%~1"") ELSE (SET "SCRIPT_PARAMS=%SCRIPT_PARAMS% "%~1"")
EXIT /B 0

:showUsage
ECHO 参数错误！使用方法：
ECHO msys2shell.cmd [/m msys2_home_dir] [/e msys2^|mingw64^|ucrt64^|clang64] [script] [script params]

:error
PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)
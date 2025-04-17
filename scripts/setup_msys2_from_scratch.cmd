@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

ECHO ����msys2��װ��...
IF EXIST msys2-x86_64-latest.sfx.exe (
    ECHO "msys2-x86_64-latest.sfx.exe" �ļ��Ѵ��ڣ��������ء�
) ELSE (
    curl https://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe -o msys2-x86_64-latest.sfx.exe || GOTO :error
    ECHO ������ɡ�& ECHO.
)

ECHO ��ѹmsys2��װ��...
CD ..
SET MSYS2_DIR=%CD%
CD "%~dp0"
SET /P MSYS2_DIR="����msys2��װ·��(Ĭ��·��Ϊ%MSYS2_DIR%)��"
IF EXIST "%MSYS2_DIR%\msys64" (
    ECHO Ŀ��Ŀ¼�Ѵ��ڣ�"%MSYS2_DIR%\msys64"��������ѹ��
) ELSE ��
    IF NOT EXIST %MSYS2_DIR% (MKDIR %MSYS2_DIR% || (ECHO ����Ŀ¼����& GOTO :error))
    msys2-x86_64-latest.sfx.exe -o"%MSYS2_DIR%" || GOTO :error
    ECHO ��ѹ��ɡ�& ECHO.
)

ECHO ����msys2ϵͳ...
SET "msys2_shell_cmd=%MSYS2_DIR%\msys64\msys2_shell.cmd -no-start -full-path -defterm -msys2 -where "%CD%"" 
START /WAIT CMD /C %msys2_shell_cmd% update_pkgs.sh
IF ERRORLEVEL 2 (ECHO ����msys2ϵͳ����& GOTO :error)
START /WAIT CMD /C %msys2_shell_cmd% update_pkgs.sh
IF NOT %ERRORLEVEL% == 0 (ECHO ����msys2ϵͳ����& GOTO :error)
ECHO ����msys2ϵͳ��ɡ�& ECHO.

SET "msys2_shell_cmd=%MSYS2_DIR%\msys64\msys2_shell.cmd -no-start -full-path -defterm -ucrt64 -where "%CD%"" 

ECHO ��װ����Ϳ�...
CALL %msys2_shell_cmd% inst_pkgs.sh ucrt64
IF NOT %ERRORLEVEL% == 0 (ECHO ����Ϳⰲװ����& GOTO :error)
ECHO ����Ϳⰲװ��ɡ�& ECHO.

ECHO ��װcapsimage...
CALL %msys2_shell_cmd% inst_capsimage.sh
IF NOT %ERRORLEVEL% == 0 (ECHO capsimage��װ����& GOTO :error)
ECHO capsimage��װ��ɡ�& ECHO.

ECHO ����ǰmsys2��װĿ¼д��msys2shell.ini�����ļ�...
ECHO MSYS2_HOME=%MSYS2_DIR%\msys64>msys2shell.ini
ECHO COMPILER_ENV=ucrt64>>msys2shell.ini
ECHO д����ɡ�& ECHO.

ECHO ȫ��������ɣ�
POPD & EXIT /B %ERRORLEVEL%

:error
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)
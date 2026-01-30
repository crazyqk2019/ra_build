@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

PUSHD ..\..\
SET "INST_DEST=%CD%"
POPD

ECHO 解压Python……
..\tools\7za.exe x -y -bso0 -o..\ tools\python.7z
ECHO 完成。& ECHO.

ECHO 全部工作完成！
POPD & EXIT /B %ERRORLEVEL%

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)
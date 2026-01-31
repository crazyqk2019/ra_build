@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

IF "%~2" == "" (ECHO 参数错误！& EXIT /B 1)

PUSHD ..
IF NOT EXIST cores MKDIR cores
IF NOT EXIST cores\dists MKDIR cores\dists
SET "CORES_DIR=%CD%\cores"
SET "DISTS_DIR=%CD%\cores\dists"
POPD

REM 调用cmake编译，REM 参数说明：
REM %1 - 内核显示名称
REM %2 - 内核名称
REM %3 - 编译源代码路径（CMakeLists.txt文件路径），默认为内核源代码根目录
REM %4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
REM %5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
REM %6 - 指定编译临时目录，默认为Build
SET core_name=%~1
SET core=%~2
IF "%~3" == "" (SET "core_src=.") ELSE (SET "core_src=%~3")
IF "%~4" == "" (SET "core_dest=.") ELSE (SET "core_dest=%~4")
IF "%~5" == "" (SET "core_output=%core%_libretro.dll") ELSE (SET "core_output=%~5")
IF "%~6" == "" (SET "build_dir=Build") ELSE (SET "build_dir=%~6")

REM ECHO core_output=%core_output%
REM ECHO build_dir=%build_dir%
IF NOT EXIST "%CORES_DIR%\libretro-%core%\%core_src%" (
    ECHO 内核目录不存在，请先拉取内核源代码："%core_name%"
    GOTO :err
)
CD "%CORES_DIR%\libretro-%core%\%core_src%"
IF NOT DEFINED NO_CLEAN (
REM    IF EXIST "%build_dir%" (
REM        ECHO 清理 "%core_name%" ^(cmake --build %build_dir% --target clean --parallel^)...
REM        cmake --build %build_dir% --target clean --parallel
REM        ECHO.
REM    )
    ECHO 清理 "%core_name%"，删除编译目录 ^(RD /S /Q "%build_dir%"^)...
    IF EXIST "%build_dir%" RD /S /Q "%build_dir%"
    ECHO.
)
SET "cmake_commad_line=cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -A x64"
REM -DCMAKE_POLICY_VERSION_MINIMUM=3.5
IF DEFINED cmake_vcpkg_params (
    SET "cmake_commad_line=%cmake_commad_line% %cmake_vcpkg_params% -DVCPKG_INSTALLED_DIR=vcpkg_installed -DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake"
)
IF DEFINED cmake_params (
    SET "cmake_commad_line=%cmake_commad_line% %cmake_params%"
)
SET "cmake_commad_line=%cmake_commad_line% . -B %build_dir%"
ECHO 生成编译配置文件 ^(%cmake_commad_line%^)...
%cmake_commad_line% 
IF NOT %ERRORLEVEL% == 0 GOTO :err
ECHO.
ECHO 编译 "%core_name%" ^(cmake --build "%build_dir%" --target %core%_libretro --config Release --parallel -- /p:Platform=x64^)...
cmake --build "%build_dir%" --target %core%_libretro --config Release --parallel -- /p:Platform=x64
IF NOT %ERRORLEVEL% == 0  GOTO :err
ECHO.
COPY /Y "%core_dest%\%core_output%" "%DISTS_DIR%\%core_output%"
IF NOT %ERRORLEVEL% == 0 (ECHO 拷贝内核到分发目录出错！& GOTO :err)
GOTO :end


:err
POPD
ECHO "%core_name%" 编译出错！
ECHO.
IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

:end
POPD
ECHO "%core_name%" 编译完成。
ECHO.
EXIT /B %ERRORLEVEL%


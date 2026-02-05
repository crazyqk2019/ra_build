@ECHO OFF
SETLOCAL

IF "%~2" == "" (ECHO 参数错误！& EXIT /B 1)

PUSHD "%~dp0"

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
IF "%~6" == "" (SET "build_dir=vc_build") ELSE (SET "build_dir=%~6")

SET "cmake_clean=cmake --build %build_dir% --target clean -j"
SET "cmake_gen=cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -G Ninja"
IF DEFINED cmake_params (SET "cmake_gen=%cmake_gen% %cmake_params%")
SET "cmake_gen=%cmake_gen% -B %build_dir%"
SET "cmake_build=cmake --build "%build_dir%" --target %core%_libretro --config Release -j"
IF DEFINED BUILD_MT SET "cmake_build=%cmake_build% %BUILD_MT%"

REM IF DEFINED cmake_vcpkg_params (
REM    SET "cmake_commad_line=%cmake_commad_line% %cmake_vcpkg_params% -DVCPKG_INSTALLED_DIR=vcpkg_installed -DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake"
REM )
REM -DCMAKE_POLICY_VERSION_MINIMUM=3.5

IF NOT EXIST "%CORES_DIR%\libretro-%core%\%core_src%" (ECHO 内核 "%core_name%" 目录 "%CORES_DIR%\libretro-%core%\%core_src%" 不存在，请先拉取内核源代码！& GOTO :err)
CD "%CORES_DIR%\libretro-%core%\%core_src%"

IF NOT DEFINED NO_REGEN IF EXIST "%build_dir%" (
    ECHO 删除内核 "%core_name%" 编译目录 ^(RD /S /Q "%build_dir%"^)……
    RD /S /Q "%build_dir%" || (ECHO 删除 "%core_name%" 编译目录出错！& GOTO :err)
    ECHO.
)

IF NOT DEFINED NO_CLEAN IF EXIST "%build_dir%\build.ninja" (
   ECHO 清理内核 "%core_name%" ^(%cmake_clean%^)...
   %cmake_clean%
   ECHO.
)

IF NOT EXIST "%build_dir%\build.ninja" (
    ECHO 生成内核 "%core_name%" 编译配置文件 ^(%cmake_gen%^)...
    %cmake_gen% || (ECHO 生成内核 %core_name% 编译配置文件出错！& GOTO :err)
    ECHO.
)

ECHO 编译内核 "%core_name%" ^(%cmake_build%^)...
%cmake_build% || (ECHO 编译内核 "%core_name%" 出错！& GOTO :err)
ECHO.

CD "%CORES_DIR%\libretro-%core%\%core_src%"
COPY /Y "%core_dest%\%core_output%" "%DISTS_DIR%\%core_output%" ||(ECHO 拷贝内核 "%core_name%" dll文件到分发目录出错！& GOTO :err)
ECHO.

ECHO 编译内核 "%core_name%" 完成。
ECHO.
POPD
EXIT /B 0

:err
ECHO.
POPD
IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)


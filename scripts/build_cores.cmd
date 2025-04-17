@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

SET "CORES_LIST=dolphin citra ppsspp dosbox_pure play pcsx2 swanstation tic80"

IF "%~1" == "" GOTO :showUsage

SET "NO_CLEAN="
SET "_param_=%~1"
IF "%_param_:~0,1%" == "/" (
    IF /I "%~1" == "/noclean" (SET "NO_CLEAN=1") ELSE (GOTO :showUsage)
    SHIFT /1
)

CALL :check_cores %* || GOTO :showUsage

CD ..
IF NOT EXIST cores MKDIR cores
IF NOT EXIST cores\dists MKDIR cores\dists
SET "CORES_DIR=%CD%\cores"
SET "DISTS_DIR=%CD%\cores\dists"
CD cores

IF /I "%~1" == "all" (
    CALL :build_all
) ELSE (
    CALL :build_cores %*
)
IF %ERRORLEVEL% == 0 (GOTO :end) ELSE (GOTO :err)

REM 调用cmake编译，REM 参数说明：
REM %1 - 内核显示名称
REM %2 - 内核名称
REM %3 - 编译源代码路径（CMakeLists.txt文件路径），默认为内核源代码根目录
REM %4 - 编译输出路径（相对于上一个参数指定的源代码路径），默认为和编译源代码路径相同
REM %5 - 编译输出内核dll文件名，默认为 "内核名称_libretro.dll"
REM %6 - 指定编译目录，默认为Build
:common_build_cmake
SET core_name=%~1
SET core=%~2
IF "%~3" == "" (SET "core_src=.") ELSE (SET "core_src=%~3")
IF "%~4" == "" (SET "core_dest=.") ELSE (SET "core_dest=%~4")
IF "%~5" == "" (SET "core_output=%core%_libretro.dll") ELSE (SET "core_output=%~5")
IF "%~6" == "" (SET "build_dir=Build") ELSE (SET "build_dir=%~6")
REM ECHO core_output=%core_output%
REM ECHO build_dir=%build_dir%
PUSHD "libretro-%core%\%core_src%"
IF NOT DEFINED NO_CLEAN (
    IF EXIST "%build_dir%" (
        ECHO 清理 "%core_name%" ^(cmake --build %build_dir% --target clean --parallel^)...
        cmake --build %build_dir% --target clean --parallel
        ECHO.
    )
    ECHO 清理 "%core_name%"，删除编译目录 ^(RD /S /Q "%build_dir%"^)...
    IF EXIST "%build_dir%" RD /S /Q "%build_dir%"
    ECHO.
)
SET "cmake_commad_line=cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -A x64"
IF DEFINED cmake_vcpkg_params SET "cmake_commad_line=%cmake_commad_line% %cmake_vcpkg_params% -DVCPKG_INSTALLED_DIR=vcpkg_installed -DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake"
IF DEFINED cmake_params SET "cmake_commad_line=%cmake_commad_line% %cmake_params%"
SET "cmake_commad_line=%cmake_commad_line% . -B %build_dir%"
ECHO 生成编译配置文件 ^(%cmake_commad_line%^)...
%cmake_commad_line% 
IF NOT %ERRORLEVEL% == 0 (POPD & ECHO "%core_name%" 编译出错！& EXIT /B %ERRORLEVEL%)
ECHO.
ECHO 编译 "%core_name%" ^(cmake --build "%build_dir%" --target %core%_libretro --config Release --parallel -- /p:Platform=x64^)...
cmake --build "%build_dir%" --target %core%_libretro --config Release --parallel -- /p:Platform=x64
IF NOT %ERRORLEVEL% == 0 (POPD & ECHO "%core_name%" 编译出错！& EXIT /B %ERRORLEVEL%)
ECHO.
COPY "%core_dest%\%core_output%" "%DISTS_DIR%\"
IF NOT %ERRORLEVEL% == 0 (POPD & ECHO "%core_name%" 编译出错！& EXIT /B %ERRORLEVEL%)
ECHO.
ECHO "%core_name%" 编译完成。& ECHO.
POPD & EXIT /B 0

:build_dolphin
SETLOCAL
SET "cmake_params=-DLIBRETRO=ON"
CALL :common_build_cmake "Dolphin" "dolphin" "." "Binary"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_citra
SETLOCAL
SET "cmake_params=-DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF"
CALL :common_build_cmake "Citra" "citra" "." "Build\bin\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_ppsspp
SETLOCAL
ECHO "Update glslang external sources..."
PUSHD "libretro-ppsspp\ext\glslang"
python update_glslang_sources.py
POPD
IF NOT %ERRORLEVEL% == 0 (ENDLOCAL & ECHO "PPSSPP" 编译出错！& EXIT /B %ERRORLEVEL%)
REM SET "cmake_vcpkg_params=-DVCPKG_TARGET_TRIPLET=x64-windows-release"
REM SET "cmake_params=-DLIBRETRO=ON -DUSE_SYSTEM_SNAPPY=ON -DUSE_SYSTEM_FFMPEG=ON -DUSE_SYSTEM_LIBZIP=ON -DUSE_SYSTEM_LIBSDL2=ON -DUSE_SYSTEM_LIBPNG=ON -DUSE_SYSTEM_ZSTD=ON -DUSE_SYSTEM_MINIUPNPC=ON -DCMAKE_C_FLAGS_RELEASE="/MD /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MD /utf-8""
SET "cmake_params=-DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/MD /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MD /utf-8""
CALL :common_build_cmake "PPSSPP" "ppsspp" "." "Build\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_play
SETLOCAL
SET "cmake_params=-DBUILD_PLAY=OFF -DBUILD_LIBRETRO_CORE=ON -DBUILD_TESTS=OFF"
CALL :common_build_cmake "Play!" "play" "." "Build\Source\ui_libretro\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_pcsx2
SETLOCAL
SET "cmake_params=-DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/utf-8""
CALL :common_build_cmake "PCSX2" "pcsx2" "." "Build\pcsx2\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_swanstation
SETLOCAL
CALL :common_build_cmake "SwanStation" "swanstation" "." "Build"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_tic80
SETLOCAL
SET "cmake_params=-DBUILD_SDLGPU=On -DBUILD_WITH_ALL=On -DBUILD_LIBRETRO=ON -DPREFER_SYSTEM_LIBRARIES=ON"
CALL :common_build_cmake "TIC-80" "tic80" "." "Build1\bin" "" "Build1"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_dosbox_pure
PUSHD libretro-dosbox_pure
IF NOT DEFINED NO_CLEAN (
    ECHO 清理 "DOSBox Pure"...
    IF EXIST build RD /S /Q build
    ECHO.
)
msbuild dosbox_pure_libretro.vcxproj -maxCpuCount -p:Platform=x64;Configuration=Release
IF %ERRORLEVEL% == 0 (COPY "build\Release_64bit\dosbox_pure_libretro.dll" "%DISTS_DIR%\")
IF NOT %ERRORLEVEL% == 0 (ECHO "DOSBox Pure" 编译出错！)
POPD & EXIT /B %ERRORLEVEL%

:build_all
FOR %%# IN (%CORES_LIST%) DO (
    IF NOT EXIST "%CORES_DIR%\libretro-%%#" (
        ECHO 内核目录不存在，请先拉取内核源代码："%%#" & ECHO.
    ) ELSE (
        CALL :build_%%#
        EXIT /B %ERRORLEVEL%
    )
)
EXIT /B 0

:build_cores
IF /I "%~1" == "/noclean" SHIFT /1
:build_core
IF /I "%~1" == "" EXIT /B 0
IF NOT EXIST "%CORES_DIR%\libretro-%~1" (
    ECHO 内核目录不存在，请先拉取内核源代码："%~1" & ECHO.
) ELSE (
    CALL :build_%~1
    EXIT /B %ERRORLEVEL%
)
SHIFT & GOTO :build_core

:check_cores
IF /I "%~1" == "/noclean" SHIFT /1
IF /I "%~1" == "" EXIT /B 1
IF /I "%~1" == "all" EXIT /B 0
:check_core
IF /I "%~1" == "" EXIT /B 0
ECHO %CORES_LIST% | findstr /i "\<%~1\>" >NUL || (ECHO 内核不存在："%~1" & EXIT /B 1)
SHIFT & GOTO :check_core

:showUsage
ECHO 参数错误。使用方法：
ECHO %~nx0 [/noclean] all ^| core1 [core2]...
ECHO.
ECHO   /noclean         - 编译之前不要执行清理。
ECHO   all              - 编译所有内核。
ECHO   core1 [core2]... -  编译指定的内核。
ECHO. 
ECHO 可用内核：
FOR %%# IN (%CORES_LIST%) DO ECHO   %%#
ECHO.

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

:end
POPD & EXIT /B %ERRORLEVEL%


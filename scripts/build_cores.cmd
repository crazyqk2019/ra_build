@ECHO OFF
SETLOCAL

SET "DO_NOT_CLEAN="
IF /I "%~1" == "-noclean" SET "DO_NOT_CLEAN=1" ELSE IF /I "%~1" == "/noclean" SET "DO_NOT_CLEAN=1"
IF DEFINED DO_NOT_CLEAN SHIFT

SET "CORES_LIST=dolphin citra ppsspp dosbox_pure play pcsx2 swanstation tic80"

IF "%~1" == "" (
    ECHO 需要指定内核名称！可用内核：
    FOR %%# IN (%CORES_LIST%) DO ECHO %%#
    ECHO.
    ECHO 示例：
    ECHO # 编译指定内核：
    ECHO ./build_cores.sh [-noclean] core1 core2
    ECHO # 编译所有内核：
    ECHO ./build_cores.sh [-noclean] all
    EXIT /B 1
)

PUSHD "%~dp0"

CALL :check_cores %* || GOTO :err

CD ..
IF NOT EXIST cores MKDIR cores
SET "CORES_DIR=%CD%\cores"
CD cores
IF NOT EXIST dists MKDIR dists
SET "DISTS_DIR=%CD%\dists"

IF /I "%~1" == "all" (
    CALL :build_all
) ELSE (
    CALL :build_cores %*
)
IF %ERRORLEVEL% NEQ 0 GOTO :err
GOTO :end

REM 参数说明：
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
ECHO core_output=%core_output%
ECHO build_dir=%build_dir%
PUSHD "libretro-%core%\%core_src%"
IF NOT DEFINED DO_NOT_CLEAN (
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
%cmake_commad_line% || (ECHO "%core_name%" 编译出错！& POPD & EXIT /B 1)
ECHO.
ECHO 编译 "%core_name%" ^(cmake --build "%build_dir%" --target %core%_libretro --config Release --parallel -- /p:Platform=x64^)...
cmake --build "%build_dir%" --target %core%_libretro --config Release --parallel -- /p:Platform=x64 || (ECHO "%core_name%" 编译出错！& POPD & EXIT /B 1)
ECHO.
COPY "%core_dest%\%core_output%" "%DISTS_DIR%\" || (ECHO "%core_name%" 编译出错！& POPD & EXIT /B 1)
ECHO.
ECHO "%core_name%" 编译完成。& ECHO.
POPD
EXIT /B 0


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
IF %ERRORLEVEL% NEQ 0 (ENDLOCAL & EXIT /B %ERRORLEVEL%)
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
IF NOT DEFINED DO_NOT_CLEAN (
    ECHO 清理 "DOSBox Pure"...
    IF EXIST build RD /S /Q build
    ECHO.
)
msbuild dosbox_pure_libretro.vcxproj -maxCpuCount -p:Platform=x64;Configuration=Release
IF %ERRORLEVEL% EQU 0 (COPY "build\Release_64bit\dosbox_pure_libretro.dll" "%DISTS_DIR%\")
IF %ERRORLEVEL% NEQ 0 (ECHO "DOSBox Pure" 编译出错！)
POPD & EXIT /B %ERRORLEVEL%

:build_all
FOR %%# IN (%CORES_LIST%) DO (
    IF NOT EXIST "%CORES_DIR%\libretro-%%#" (
        ECHO 内核目录不存在，请先拉取内核源代码："%%#" & ECHO.
    ) ELSE (
        CALL :build_%%# || EXIT /B 1
    )
)
EXIT /B 0

:build_cores
IF /I "%~1" == "-noclean" (SHIFT) ELSE IF /I "%~1" == "/noclean" (SHIFT)
:build_core
IF /I "%~1" == "" EXIT /B 0
CALL :build_%~1 || EXIT /B 1
SHIFT
GOTO :build_core

:check_cores
IF /I "%~1" == "all" EXIT /B 0
IF /I "%~1" == "-noclean" (SHIFT) ELSE IF /I "%~1" == "/noclean" (SHIFT)
:check_core
IF /I "%~1" == "" EXIT /B 0
ECHO %CORES_LIST% | findstr /i "\<%~1\>" >NUL || (ECHO 参数错误，内核不存在："%~1" & EXIT /B 1)
SHIFT
GOTO :check_core

:end
POPD
EXIT /B 0

:err
POPD
EXIT /B 1
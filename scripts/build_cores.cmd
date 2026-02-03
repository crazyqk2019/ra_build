@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

PUSHD ..
SET "CORES_DIR=%CD%\cores"
SET "DISTS_DIR=%CD%\cores\dists"
POPD

SET "CORES_LIST=dolphin citra ppsspp play pcsx2 swanstation tic80"

SET "NO_CLEAN="
SET "NO_REGEN="
SET "BUILD_ALL="
SET "BUILD_CORES_LIST="

:parseParamsBegin
IF "%~1" == "" GOTO :parseParamsEnd
IF /I "%~1" == "-noclean" (SET "NO_CLEAN=1" & SHIFT & GOTO :parseParamsBegin)
IF /I "%~1" == "/noclean" (SET "NO_CLEAN=1" & SHIFT & GOTO :parseParamsBegin)
IF /I "%~1" == "-noregen" (SET "NO_REGEN=1" & SHIFT & GOTO :parseParamsBegin)
IF /I "%~1" == "/noregen" (SET "NO_REGEN=1" & SHIFT & GOTO :parseParamsBegin)
IF /I "%~1" == "all" (SET "BUILD_ALL=1" & SHIFT & GOTO :parseParamsBegin)
ECHO %CORES_LIST% | findstr /i "\<%~1\>" >NUL || (ECHO 参数错误，内核 "%~1" 不存在! & GOTO :err)
IF NOT EXIST "%CORES_DIR%\libretro-%~1" (ECHO 内核 "%~1" 源代码目录不存在！& GOTO :err)
IF NOT DEFINED BUILD_CORES_LIST (SET "BUILD_CORES_LIST=%~1") ELSE (SET "BUILD_CORES_LIST=%BUILD_CORES_LIST% %~1")
:parseParamsEnd

IF DEFINED BUILD_ALL (SET "BUILD_CORES_LIST=%CORES_LIST%")

IF NOT DEFINED BUILD_ALL IF NOT DEFINED BUILD_CORES_LIST (
    ECHO "需要指定编译内核，或指定 "all" 编译所有内核。可用内核列表："
    FOR %%# IN (%CORES_LIST%) DO ECHO   %%#
    ECHO
    ECHO "示例："
    ECHO "编译指定内核：build_cores.cmd [-noclean] [-noregen] [-noccache] core1 core2"
    ECHO "编译所有内核：build_cores.cmd [-noclean] [-noregen] [-noccache] all"
    ECHO "-noclean: 编译前不要执行清理操作"
    ECHO "-noregen: 对于使用CMake编译的内核，不要重新创建编译配置文件"
    GOTO :end
)

IF NOT EXIST "%DISTS_DIR%" MD "%DISTS_DIR%" || (ECHO 创建内核分发目录出错！& GOTO :err)

CALL :buildCores || GOTO :err
ECHO 全部编译完成。
GOTO :end


:build_dolphin
SETLOCAL
SET "cmake_params=-DLIBRETRO=ON"
CALL build_use_cmake.cmd "Dolphin" "dolphin" "." "Binary"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_citra
SETLOCAL
SET "cmake_params=-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF"
CALL build_use_cmake.cmd "Citra" "citra" "." "vc_build\bin\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_ppsspp
SETLOCAL
ECHO "更新 glslang 外部源代码……"
PUSHD "%CORES_DIR%\libretro-ppsspp\ext\glslang"
python update_glslang_sources.py
POPD
IF NOT %ERRORLEVEL% == 0 (ENDLOCAL & ECHO "PPSSPP" 编译出错！& EXIT /B %ERRORLEVEL%)
REM SET "cmake_vcpkg_params=-DVCPKG_TARGET_TRIPLET=x64-windows-release"
REM SET "cmake_params=-DLIBRETRO=ON -DUSE_SYSTEM_SNAPPY=ON -DUSE_SYSTEM_FFMPEG=ON -DUSE_SYSTEM_LIBZIP=ON -DUSE_SYSTEM_LIBSDL2=ON -DUSE_SYSTEM_LIBPNG=ON -DUSE_SYSTEM_ZSTD=ON -DUSE_SYSTEM_MINIUPNPC=ON -DCMAKE_C_FLAGS_RELEASE="/MD /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MD /utf-8""
SET "cmake_params=-DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/MD /utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/MD /utf-8""
CALL build_use_cmake.cmd "PPSSPP" "ppsspp" "." "Build\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_play
SETLOCAL
SET "cmake_params=-DBUILD_PLAY=OFF -DBUILD_LIBRETRO_CORE=ON -DBUILD_TESTS=OFF"
CALL build_use_cmake.cmd "Play!" "play" "." "Build\Source\ui_libretro\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_pcsx2
SETLOCAL
SET "cmake_params=-DLIBRETRO=ON -DCMAKE_C_FLAGS_RELEASE="/utf-8" -DCMAKE_CXX_FLAGS_RELEASE="/utf-8""
CALL build_use_cmake.cmd "PCSX2" "pcsx2" "." "Build\pcsx2\Release"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_swanstation
SETLOCAL
CALL build_use_cmake.cmd "SwanStation" "swanstation" "." "Build"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_tic80
SETLOCAL
SET "cmake_params=-DBUILD_SDLGPU=On -DBUILD_WITH_ALL=On -DBUILD_LIBRETRO=ON -DPREFER_SYSTEM_LIBRARIES=ON"
CALL build_use_cmake.cmd "TIC-80" "tic80" "." "Build1\bin" "" "Build1"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_dosbox_pure
PUSHD "%CORES_DIR%\libretro-dosbox_pure"
IF NOT DEFINED NO_CLEAN (
    ECHO 清理 "DOSBox Pure"...
    IF EXIST build RD /S /Q build
    ECHO.
)
msbuild dosbox_pure_libretro.vcxproj -maxCpuCount -p:Platform=x64;Configuration=Release
IF %ERRORLEVEL% == 0 (COPY /Y "build\Release_64bit\dosbox_pure_libretro.dll" "%DISTS_DIR%\dosbox_pure_libretro.dll")
IF NOT %ERRORLEVEL% == 0 (ECHO "DOSBox Pure" 编译出错！)
POPD & EXIT /B %ERRORLEVEL%

:buildCores
FOR %%# IN (%BUILD_CORES_LIST%) DO (
    CALL :build_%%~# || EXIT /B 1
)
EXIT /B 0

:err
POPD & PAUSE & IF %ERRORLEVEL% == 0 (EXIT /B 1) ELSE (EXIT /B %ERRORLEVEL%)

:end
POPD & EXIT /B %ERRORLEVEL%


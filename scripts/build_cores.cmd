@ECHO OFF
SETLOCAL

PUSHD "%~dp0"

SET "CORES_LIST=dolphin citra ppsspp play pcsx2 swanstation tic80"

IF "%~1" == "" GOTO :showUsage

SET "NO_CLEAN="
SET "_param_=%~1"
IF "%_param_:~0,1%" == "/" (
    IF /I "%~1" == "/noclean" (SET "NO_CLEAN=1") ELSE (GOTO :showUsage)
    SHIFT /1
)

CALL :check_cores %* || GOTO :showUsage

PUSHD ..
IF NOT EXIST cores MKDIR cores
IF NOT EXIST cores\dists MKDIR cores\dists
SET "CORES_DIR=%CD%\cores"
SET "DISTS_DIR=%CD%\cores\dists"
POPD


IF /I "%~1" == "all" (
    CALL :build_all
) ELSE (
    CALL :build_cores %*
)
IF %ERRORLEVEL% == 0 (GOTO :end) ELSE (GOTO :err)


:build_dolphin
SETLOCAL
SET "cmake_params=-DLIBRETRO=ON"
CALL build_use_cmake.cmd "Dolphin" "dolphin" "." "Binary"
ENDLOCAL & EXIT /B %ERRORLEVEL%

:build_citra
SETLOCAL
SET "cmake_params=-DENABLE_LIBRETRO=ON -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_WEB_SERVICE=OFF -DCITRA_WARNINGS_AS_ERRORS=OFF"
CALL build_use_cmake.cmd "Citra" "citra" "." "Build\bin\Release"
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

:build_all
FOR %%# IN (%CORES_LIST%) DO (CALL :build_%%# || EXIT /B 1)
EXIT /B 0

:build_cores
FOR %%# IN (%*) DO (
    IF /I "%%~#" NEQ "/noclean" (CALL :build_%%~# || EXIT /B 1)
)
EXIT /B 0

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


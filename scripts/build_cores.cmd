@ECHO OFF
SETLOCAL

SET "DO_NOT_CLEAN="
IF /I "%~1" == "-noclean" SET "DO_NOT_CLEAN=1" ELSE IF /I "%~1" == "/noclean" SET "DO_NOT_CLEAN=1"
IF DEFINED DO_NOT_CLEAN SHIFT

SET "CORES_LIST=dolphin citra ppsspp dosbox_pure"

IF "%~1" == "" (
    ECHO ��Ҫָ���ں����ƣ������ںˣ�
    FOR %%# IN (%CORES_LIST%) DO ECHO %%#
    ECHO.
    ECHO ʾ����
    ECHO # ����ָ���ںˣ�
    ECHO ./build_cores.sh [-noclean] core1 core2
    ECHO # ���������ںˣ�
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

REM ����˵����
REM %1 - �ں���ʾ����
REM %2 - �ں�����
REM %3 - ����Դ����·����CMakeLists.txt�ļ�·������Ĭ��Ϊ�ں�Դ�����Ŀ¼
REM %4 - �������·�����������һ������ָ����Դ����·������Ĭ��Ϊ�ͱ���Դ����·����ͬ
REM %5 - ��������ں�dll�ļ�����Ĭ��Ϊ "�ں�����_libretro.dll"
:common_build_cmake
SET core_name=%~1
SET core=%~2
IF "%~3" == "" (SET "core_src=.") ELSE (SET "core_src=%~3")
IF "%~4" == "" (SET "core_dest=.") ELSE (SET "core_dest=%~4")
IF "%~5" == "" (SET "core_output=%core%_libretro.dll") ELSE (SET "core_output=%~5")    
PUSHD "libretro-%core%\%core_src%"
IF NOT DEFINED DO_NOT_CLEAN (
    ECHO ���� "%core_name%"...
    IF EXIST Binary RD /S /Q Binary
    IF EXIST Build RD /S /Q Build
    ECHO.
)
SET "cmake_commad_line=cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -A x64"
IF DEFINED cmake_vcpkg_params SET "cmake_commad_line=%cmake_commad_line% %cmake_vcpkg_params% -DVCPKG_INSTALLED_DIR=vcpkg_installed -DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake"
IF DEFINED cmake_params SET "cmake_commad_line=%cmake_commad_line% %cmake_params%"
SET "cmake_commad_line=%cmake_commad_line% . -B Build"
ECHO ���� CMake ���� Build �ļ� (%cmake_commad_line%)...
%cmake_commad_line% || (ECHO "%core_name%" �������& POPD & EXIT /B 1)
ECHO.
ECHO ���� "%core_name%" (cmake --build Build --target %core%_libretro --config Release -- /p:Platform=x64)...
cmake --build Build --target %core%_libretro --config Release -- /p:Platform=x64 || (ECHO "%core_name%" �������& POPD & EXIT /B 1)
ECHO.
COPY "%core_dest%\%core_output%" "%DISTS_DIR%\" || (ECHO "%core_name%" �������& POPD & EXIT /B 1)
ECHO.
ECHO "%core_name%" ������ɡ�& ECHO.
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

:build_all
FOR %%# IN (%CORES_LIST%) DO (
    IF NOT EXIST "%CORES_DIR%\libretro-%%#" (
        ECHO �ں�Ŀ¼�����ڣ�������ȡ�ں�Դ���룺"%%#" & ECHO.
    ) ELSE (
        CALL :build_%%# || EXIT /B 1
    )
)
EXIT /B 0

:build_dosbox_pure
PUSHD libretro-dosbox_pure
IF NOT DEFINED DO_NOT_CLEAN (
    ECHO ���� "DOSBox Pure"...
    IF EXIST build RD /S /Q build
    ECHO.
)
msbuild dosbox_pure_libretro.vcxproj -maxCpuCount:8 -p:Platform=x64;Configuration=Release
IF %ERRORLEVEL% EQU 0 (COPY "build\Release_64bit\dosbox_pure_libretro.dll" "%DISTS_DIR%\")
IF %ERRORLEVEL% NEQ 0 (ECHO "DOSBox Pure" �������)
POPD & EXIT /B %ERRORLEVEL%


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
ECHO %CORES_LIST% | findstr /i "\<%~1\>" >NUL || (ECHO ���������ں˲����ڣ�"%~1" & EXIT /B 1)
SHIFT
GOTO :check_core

:end
POPD
EXIT /B 0

:err
POPD
EXIT /B 1
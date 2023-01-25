SET ORIGINAL_DIR=%cd%
SET PB_LIBRARY_PATH=%~dp0
SET PB_LIBRARY_PATH=%PB_LIBRARY_PATH:~0,-1%
echo %PB_LIBRARY_PATH%

:: ### Windows ###
rmdir /s /q %PB_LIBRARY_PATH%\build\_win64
mkdir %PB_LIBRARY_PATH%\build\_win64 & cd %PB_LIBRARY_PATH%\build\_win64
cmake -G "Visual Studio 16 2019" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%PB_LIBRARY_PATH%/libprotobuf ^
 -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>DLL" ^
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
 -Dprotobuf_DEBUG_POSTFIX="" ^
 -DCMAKE_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/win64/cmake ^
 -Dprotobuf_MSVC_STATIC_RUNTIME=false ^
 -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
 %PB_LIBRARY_PATH%/protobuf-source/cmake
cmake --build . --target INSTALL --config Debug
cmake --build . --target INSTALL --config Release

:: ### Android ####
:: !!! change to your path
set NDK_CMAKE_VERSION=3.22.1
set ANDROID_HOME=%USERPROFILE%\AppData\Local\Android\Sdk
set NDKROOT=C:\Users\user\AppData\Local\Android\Sdk\ndk\25.1.8937393

rmdir /s /q %PB_LIBRARY_PATH%\build\_android
mkdir %PB_LIBRARY_PATH%\build\_android & cd %PB_LIBRARY_PATH%\build\_android
for /d %%a in (armeabi-v7a arm64-v8a x86_64) do (
    mkdir %%a & pushd %%a ^
    & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" -G "Ninja Multi-Config" ^
    -DCMAKE_TOOLCHAIN_FILE="%NDKROOT%\build\cmake\android.toolchain.cmake" ^
    -DCMAKE_MAKE_PROGRAM=%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\ninja.exe ^
    -DANDROID_ABI=%%a -Dprotobuf_DEBUG_POSTFIX="" ^
    -DCMAKE_INSTALL_PREFIX=%PB_LIBRARY_PATH%/libprotobuf ^
    -DCMAKE_INSTALL_LIBDIR="lib/android/%%a/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
    -DCMAKE_INSTALL_CMAKEDIR=lib/android/%%a/cmake ^
    -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
    -Dprotobuf_BUILD_PROTOC_BINARIES=false -Dprotobuf_BUILD_LIBPROTOC=false ^
    %PB_LIBRARY_PATH%/protobuf-source/cmake ^
    & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Debug ^
    & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Release ^
    & popd
)

cd %ORIGINAL_DIR%
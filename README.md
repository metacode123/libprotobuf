libprotobuf for [Unreal Engine 4][]
=====

Link the google's `protocol bufffers` library as the third party in [Unreal Engine 4][].

# Version
* [Protobuf][]: 3.19.0
* [Unreal Engine 4][]: 4.27.2

# Usage
1. Import or copy the folder `libprotobuf` into `<your project>/Source/ThirdParty/libprotobuf`.
1. Add the libprotobuf as a module into `<your project>.Build.cs`
  ```C++
  PrivateDependencyModuleNames.AddRange(new string[] { "libprotobuf" });
  ```

# Compile proto file(s)
1. Compile the proto files for [Unreal Engine 4][] by `generate_for_ue4.py`.
    * `python generate_for_ue4.py --proto_input <proto_file_or_path> --cpp_out <output_path>`
    * ex: `python generate_for_ue4.py --proto_input Message.proto --cpp_out d:\Prject\Source\ProtoFiles`
1. Include and use the header file(ex: Message.pb.h) in your `.cpp` file.

# Build Library
The environment variables required for compilation
* `PB_LIBRARY_PATH` The directory where this document is located

## Apply the patch
```
cd %PB_LIBRARY_PATH%\protobuf-source
git apply ..\build\patch\diff-base-on-3.19.0.diff
```

## 1. Windows
[Visual Studio 2019](https://visualstudio.microsoft.com/vs/older-downloads/) and [CMake][] are required
```
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
```

## 2. Android
[Android Studio](https://developer.android.com/studio) is required. And you need install other additional sdk and tools through `SDK Manager`. 
* Android NDK
* Android SDK Build-Tools
* Android SDK Command-line Tools
* CMake
make sure the following environment variables are set correctly
* `ANDROID_HOME` The directory where you installed the Android SDK, It must contain a directory called `platform-tools`.
* `NDKROOT` The directory where you unzipped the Android NDK, It must contain a file called `ndk-build.cmd`
* `NDK_CMAKE_VERSION` The version number of cmake that comes with the Android NDK, like `3.22.1`(Must later than 3.18)
```
mkdir %PB_LIBRARY_PATH%\build\_android & cd %PB_LIBRARY_PATH%\build\_android
for /d %a in (armeabi-v7a arm64-v8a x86_64) do (
mkdir %a & pushd %a ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" -G "Ninja Multi-Config" ^
 -DCMAKE_TOOLCHAIN_FILE="%NDKROOT%\build\cmake\android.toolchain.cmake" ^
 -DCMAKE_MAKE_PROGRAM=%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\ninja.exe ^
 -DANDROID_ABI=%a -Dprotobuf_DEBUG_POSTFIX="" ^
 -DCMAKE_INSTALL_PREFIX=%PB_LIBRARY_PATH%/libprotobuf ^
 -DCMAKE_INSTALL_LIBDIR="lib/android/%a/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/android/%a/cmake ^
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
 -Dprotobuf_BUILD_PROTOC_BINARIES=false -Dprotobuf_BUILD_LIBPROTOC=false ^
 %PB_LIBRARY_PATH%/protobuf-source/cmake ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Debug ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Release ^
 & popd
)
```

## 3. iOS
Xcode and CMake are required.
```
mkdir -p $PB_LIBRARY_PATH/build/_ios && cd $PB_LIBRARY_PATH/build/_ios
cmake -G "Unix Makefiles" \
 -DCMAKE_INSTALL_PREFIX=$PB_LIBRARY_PATH/libprotobuf \
 -DCMAKE_TOOLCHAIN_FILE=$PB_LIBRARY_PATH/build/ios/ios.toolchain.cmake \
 -DCMAKE_INSTALL_LIBDIR=lib/ios -DPLATFORM=OS64 \
 -DCMAKE_INSTALL_CMAKEDIR=lib/ios/cmake -DCMAKE_CXX_STANDARD=17 \
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false \
 -Dprotobuf_BUILD_EXAMPLES=false \
 -Dprotobuf_BUILD_PROTOC_BINARIES=false -Dprotobuf_BUILD_LIBPROTOC=false \
 $PB_LIBRARY_PATH/protobuf-source/cmake
cmake --build . --target install --config Release
```

# License
Use The MIT License.

# Reference
1. https://github.com/code4game/libprotobuf
1. https://unrealcommunity.wiki/standalone-dedicated-server-i5qjfc27
1. https://unrealcommunity.wiki/linking-static-libraries-using-the-build-system-1ahhe4vt
1. https://unrealcommunity.wiki/compiling-for-linux-nutp04d0
1. https://docs.unrealengine.com/4.27/en-US/SharingAndReleasing/Linux/

[Unreal Engine 4]: https://www.unrealengine.com/
[Protobuf]: https://github.com/protocolbuffers/protobuf
[CMake]:http://www.cmake.org
[Ninja]:https://ninja-build.org
[Clang cross-compile toolchain]:https://docs.unrealengine.com/4.27/en-US/SharingAndReleasing/Linux/GettingStarted/

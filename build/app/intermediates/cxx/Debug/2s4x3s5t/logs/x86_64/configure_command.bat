@echo off
"C:\\Users\\bread\\AppData\\Local\\Android\\Sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\bread\\dev\\flutter\\packages\\flutter_tools\\gradle\\src\\main\\groovy" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=23" ^
  "-DANDROID_PLATFORM=android-23" ^
  "-DANDROID_ABI=x86_64" ^
  "-DCMAKE_ANDROID_ARCH_ABI=x86_64" ^
  "-DANDROID_NDK=C:\\Users\\bread\\AppData\\Local\\Android\\Sdk\\ndk\\26.3.11579264" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\bread\\AppData\\Local\\Android\\Sdk\\ndk\\26.3.11579264" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\bread\\AppData\\Local\\Android\\Sdk\\ndk\\26.3.11579264\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\bread\\AppData\\Local\\Android\\Sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=C:\\Users\\bread\\StudioProjects\\fbla\\build\\app\\intermediates\\cxx\\Debug\\2s4x3s5t\\obj\\x86_64" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=C:\\Users\\bread\\StudioProjects\\fbla\\build\\app\\intermediates\\cxx\\Debug\\2s4x3s5t\\obj\\x86_64" ^
  "-DCMAKE_BUILD_TYPE=Debug" ^
  "-BC:\\Users\\bread\\StudioProjects\\fbla\\android\\app\\.cxx\\Debug\\2s4x3s5t\\x86_64" ^
  -GNinja ^
  -Wno-dev ^
  --no-warn-unused-cli

cmake_minimum_required(VERSION 3.4)
cmake_policy(VERSION 3.4)
project(electronpass)

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})

# Instruct CMake to run moc and rrc automatically when needed
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Apple-specific configuration
set(APPLE_SUPPRESS_X11_WARNING ON)

# ECM
find_package(ECM 1.7.0 REQUIRED NO_MODULE)
list(APPEND CMAKE_MODULE_PATH
        "${ECM_MODULE_PATH}"
        "${ECM_KDE_MODULE_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
        )

# Macros
include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Wextra -Wold-style-cast -pedantic -fexceptions")

# qCDebug() uses zero variadic arguments, so we need to disable this warning
# as it would become an error with -Werror
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-gnu-zero-variadic-macro-arguments -fexceptions")
endif()

# Find sodium
find_package(sodium REQUIRED)
include_directories(${sodium_INCLUDE_DIR})

# Find Qt5
set(REQUIRED_QT_VERSION "5.7.0")
find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED COMPONENTS
        Core Qml Quick Widgets QuickControls2)

# find libelectronpass
# find_library(ELECTRONPASS_LIB electronpass)
# find_path(ELECTRONPASS_INCLUDE electronpass)
include_directories(libelectronpass/include libelectronpass/jsoncpp)


add_subdirectory(app)
add_subdirectory(data)

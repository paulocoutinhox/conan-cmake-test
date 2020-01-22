cmake_minimum_required(VERSION 3.1)
project(Sample)

# Configurations
get_filename_component(CMAKE_SOURCE_REALPATH "${CMAKE_SOURCE_DIR}/../" REALPATH)

set(PROJECT_ROOT_PATH ${CMAKE_SOURCE_REALPATH})
set(PROJECT_BUILD_DIR ${PROJECT_ROOT_PATH}/out/build CACHE INTERNAL "")
set(PROJECT_CONAN_DIR ${PROJECT_ROOT_PATH}/out/conan CACHE INTERNAL "")
set(PROJECT_CODE_DIR ${PROJECT_ROOT_PATH}/code CACHE INTERNAL "")

# Suppress macOS X RPATH warnings and adopt new related behaviors
if(NOT CMAKE_VERSION VERSION_LESS 3.9)
    cmake_policy(SET CMP0068 NEW)
endif()

# Conan
include(${PROJECT_CONAN_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

# Merge lists
set(
    TARGET_HEADER_FILES     
    ${PROJECT_CODE_DIR}/include/lib.hpp
)

set(
    TARGET_SOURCE_FILES     
    ${PROJECT_CODE_DIR}/src/lib.cpp
)

set(
    PROJECT_SOURCE_FILES
    ${PROJECT_SOURCE_FILES}
    ${TARGET_SOURCE_FILES}
    ${TARGET_HEADER_FILES}
    CACHE INTERNAL ""
)

set(
    PROJECT_HEADER_FILES
    ${TARGET_HEADER_FILES}
    CACHE INTERNAL ""
)

# Framework links
set(PROJECT_FRAMEWORK_LINKS
    ${PROJECT_FRAMEWORK_LINKS}
	"-framework Foundation"
	CACHE INTERNAL ""
)

# C flags
set(PROJECT_CMAKE_C_FLAGS "-fobjc-arc -fobjc-abi-version=2" CACHE INTERNAL "")

# CXX flags
set(PROJECT_CMAKE_CXX_FLAGS "-fobjc-arc -fvisibility-inlines-hidden -fobjc-abi-version=2 -stdlib=libc++" CACHE INTERNAL "")

# Flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${PROJECT_CMAKE_C_FLAGS}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${PROJECT_CMAKE_CXX_FLAGS}" CACHE INTERNAL "")

# Hidden visibilty is required for C++ on iOS.
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} -O0 -g ${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS} -DNDEBUG -Os -ffast-math ${CMAKE_CXX_FLAGS_MINSIZEREL}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -DNDEBUG -O2 -g -ffast-math ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} -DNDEBUG -O3 -ffast-math ${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_C_LINK_FLAGS "-Wl,-search_paths_first ${CMAKE_C_LINK_FLAGS}")
set(CMAKE_CXX_LINK_FLAGS "-Wl,-search_paths_first ${CMAKE_CXX_LINK_FLAGS}")

# Project
include_directories(${PROJECT_CODE_DIR}/include)
add_library(Sample SHARED ${PROJECT_SOURCE_FILES})

target_link_libraries(Sample "${PROJECT_FRAMEWORK_LINKS}")
target_link_libraries(Sample "${CONAN_LIBS}")

set_target_properties(Sample PROPERTIES
    CXX_STANDARD "11"
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
    CXX_VISIBILITY_PRESET default
    PUBLIC_HEADER "${PROJECT_HEADER_FILES}"
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER "com.prsolucoes.sample"
    MACOSX_FRAMEWORK_BUNDLE_VERSION "1.0.0"
    MACOSX_FRAMEWORK_SHORT_VERSION_STRING "1.0.0"
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "9.0"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
    XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO"
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ""
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"
    XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH NO
    XCODE_ATTRIBUTE_SKIP_INSTALL YES
    XCODE_ATTRIBUTE_INSTALL_PATH "@loader_path/Frameworks"

    # Is "current version" in semantic format in Mach-O binary file
    VERSION "1.0.0"
    # Is "compatibility version" in semantic format in Mach-O binary file
    SOVERSION "1.0.0"
)

# Adapt install directory to allow distributing dylibs/frameworks in user's frameworks/application bundle
set_target_properties(Sample PROPERTIES INSTALL_NAME_DIR "@rpath")

if(NOT CMAKE_SKIP_BUILD_RPATH)
    if(CMAKE_VERSION VERSION_LESS 3.9)
        set_target_properties(Sample PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
    else()
        set_target_properties(Sample PROPERTIES BUILD_WITH_INSTALL_NAME_DIR TRUE)
    endif()
endif()

target_compile_options(Sample PUBLIC "${PROJECT_COMPILE_OPTIONS}")

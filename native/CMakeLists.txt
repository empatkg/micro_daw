cmake_minimum_required(VERSION 3.20)
project(tracktion_bridge C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(TE_ADD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

include(FetchContent)

FetchContent_Declare(
    juce
    GIT_REPOSITORY https://github.com/juce-framework/JUCE.git
    GIT_TAG        develop
)
FetchContent_MakeAvailable(juce)

FetchContent_Declare(
    tracktion_engine
    GIT_REPOSITORY https://github.com/Tracktion/tracktion_engine.git
    GIT_TAG        develop
    GIT_SUBMODULES ""
)
FetchContent_MakeAvailable(tracktion_engine)

add_library(tracktion_bridge SHARED
    src/tracktion_bridge.cpp
)

target_compile_definitions(tracktion_bridge PRIVATE
    BUILDING_TRACKTION_BRIDGE
    JUCE_WEB_BROWSER=0
    JUCE_USE_CAMERA=0
)

target_link_libraries(tracktion_bridge PRIVATE
    tracktion_engine
    juce::juce_audio_utils
    juce::juce_gui_extra
)

target_include_directories(tracktion_bridge PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

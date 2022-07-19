cmake_minimum_required(VERSION 3.12...3.21)

# Flags / Options
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(PROJECT_NAME "Vim-RPC")

project(${PROJECT_NAME} VERSION 1.0 LANGUAGES CXX)

# Add source files
file(GLOB_RECURSE SOURCE_FILES 
	${CMAKE_SOURCE_DIR}/src/*.c
	${CMAKE_SOURCE_DIR}/src/*.cpp)

# Add header files
file(GLOB_RECURSE HEADER_FILES 
	${CMAKE_SOURCE_DIR}/include/*.h
	${CMAKE_SOURCE_DIR}/include/*.hpp)

add_executable(${PROJECT_NAME} ${HEADER_FILES} ${SOURCE_FILES})

install(TARGETS ${PROJECT_NAME}
	DESTINATION ${CMAKE_INSTALL_PREFIX}
)

# Headers
target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/include/discord")

# Libraries
target_link_libraries(${PROJECT_NAME} PRIVATE discord_game_sdk)

# Compilation

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	target_compile_options(${PROJECT_NAME} PRIVATE /W4)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic -Wno-unknown-pragmas)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
	target_compile_options(${PROJECT_NAME} PRIVATE)
endif()

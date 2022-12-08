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

set(RPC_VERSION "3.2.1")
set(RPC_DIR "${CMAKE_SOURCE_DIR}/discord_sdk")

# Create the `discord_rpc` if it isn't present
if(NOT EXISTS ${RPC_DIR})
	file(MAKE_DIRECTORY ${RPC_DIR})
endif()

# Download and extract the given SDK version if it isn't there
if(NOT EXISTS "${RPC_DIR}/discord_sdk_${RPC_VERSION}.zip")
	message(STATUS "Discord SDK not downloaded: fetching...\n")

	file(DOWNLOAD "https://dl-game-sdk.discordapp.net/${RPC_VERSION}/discord_game_sdk.zip" "${RPC_DIR}/discord_sdk_${RPC_VERSION}.zip"
		EXPECTED_MD5 73e5e1b3f8413a2c7184ef17476822f2
		SHOW_PROGRESS
	)

	execute_process(
		COMMAND bash -c "unzip -d \"${RPC_DIR}\" \"${RPC_DIR}/discord_sdk_${RPC_VERSION}.zip\""
	)

	# Add `#include <cstdint>` to `types.h` to fix broken compilation for some unknown reason
	execute_process(
		COMMAND bash -c "sed -i '2s/^/#include <cstdint>\\n/' \"${RPC_DIR}/cpp/types.h\""
	)
endif()

project(${PROJECT_NAME} VERSION 1.0 LANGUAGES CXX)

# Add source files
file(GLOB_RECURSE SOURCE_FILES 
	${CMAKE_SOURCE_DIR}/src/*.c
	${CMAKE_SOURCE_DIR}/src/*.cpp
	${RPC_DIR}/cpp/*.cpp)

# Add header files
file(GLOB_RECURSE HEADER_FILES 
	${CMAKE_SOURCE_DIR}/include/*.h
	${CMAKE_SOURCE_DIR}/include/*.hpp
	${RPC_DIR}/cpp/*.h)

add_executable(${PROJECT_NAME} ${HEADER_FILES} ${SOURCE_FILES})

# Add the library and headers of the SDK
add_library(discord_game_sdk SHARED IMPORTED)
set_target_properties(discord_game_sdk PROPERTIES
	IMPORTED_LOCATION "${RPC_DIR}/lib/x86_64/discord_game_sdk.so"
	INTERFACE_INCLUDE_DIRECTORIES "${RPC_DIR}/cpp"
)

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

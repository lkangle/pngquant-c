cmake_minimum_required(VERSION 2.8)
project(advpng C)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -O3")
add_definitions(-DNDEBUG)

include_directories(
        .
        lib
        libdeflate
        zopfli
        zlib
)

file(GLOB LIB_SOURCE lib/*.c)
file(GLOB DEFLATE_SOURCE libdeflate/*.c)
file(GLOB ZOPFLI_SOURCE zopfli/*.c)
file(GLOB ZLIB_SOURCE zlib/*.c)

add_library(${PROJECT_NAME} STATIC advpng.c adv-compress.c data.c pngex.c ${LIB_SOURCE} ${DEFLATE_SOURCE} ${ZOPFLI_SOURCE} ${ZLIB_SOURCE})

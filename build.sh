#!/bin/bash

ROOT=$(pwd)

MAKE=make
CMAKE_G="Unix Makefiles"
ZLIB="libz.so"

if [[ "$(uname -s)" == "MINGW"* ]]; then
    MAKE="mingw32-make"
    CMAKE_G="MinGW Makefiles"
    # ZLIB="libz.a"
    echo "This is a Windows environment ${MAKE} ${CMAKE_G}"
else
    echo "This is not a Windows environment"
fi

# build zlib 1.3.1
if [ -f "$ROOT/zlib-1.3.1/$ZLIB" ]; then
    echo "$ZLIB already exists, skipping zlib build."
else
    cd $ROOT/zlib-1.3.1
    chmod +x ./configure
    ./configure
    $MAKE
fi

# build libpng 1.6.17
if [ -f "$ROOT/libpng-1.6.17/build/libpng.a" ]; then
    echo "libpng.a already exists, skipping libpng build."
else
    cd $ROOT/libpng-1.6.17
    mkdir build
    cd build
    cmake -G "${CMAKE_G}" -DPNG_STATIC=ON -DZLIB_LIBRARY=$ROOT/zlib-1.3.1/$ZLIB -DZLIB_INCLUDE_DIR=$ROOT/zlib-1.3.1 ..
    $MAKE
fi

cd $ROOT
chmod +x $ROOT/configure
./configure --with-openmp --enable-sse --without-cocoa --without-lcms2
$MAKE

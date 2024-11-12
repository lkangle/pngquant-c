#!/bin/bash

ROOT=$(pwd)

MAKE=make
CMAKE_FLAGS=

if [[ "$(uname -s)" == "MINGW"* ]]; then
    MAKE="mingw32-make"
    CMAKE_FLAGS="-G \"MinGW Makefiles\""
    echo "This is a Windows environment ${MAKE} ${CMAKE_FLAGS}"
else
    echo "This is not a Windows environment"
fi

# build zlib 1.3.1
cd $ROOT/zlib-1.3.1
rm -fr build
mkdir build
cd build
cmake ${CMAKE_FLAGS} ..
${MAKE}

# build libpng 1.6.17
cd $ROOT/libpng-1.6.17
rm -fr build
mkdir build
cd build
cmake ${CMAKE_FLAGS} -DPNG_STATIC=ON -DZLIB_LIBRARY=$ROOT/zlib-1.3.1/build/libz.so -DZLIB_INCLUDE_DIR=$ROOT/zlib-1.3.1 ..
${MAKE}

cd $ROOT
${MAKE} clean
chmod +x $ROOT/configure
./configure --with-openmp --enable-sse --without-cocoa --without-lcms2
${MAKE}

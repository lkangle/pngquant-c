#!/bin/bash

ROOT=$(pwd)

MAKE=make
CC=gcc
SIMD_OPTION="--enable-sse"

OS=$(uname -s)
LIB_SUFFIX=(".a" ".so" ".dylib")

if [[ "$OS" == "MINGW"* ]]; then
    MAKE="mingw32-make"
    echo "===> Windows: ${MAKE}"
elif [[ "$OS" == "Darwin" ]]; then
    CC=gcc-14
    SIMD_OPTION="--disable-sse --enable-neon"
    echo "===> MacOS"
else
    echo "===> Linux"
fi

# build zlib 1.3.1
for SUFFIX in "${LIB_SUFFIX[@]}"; do
    if [[ -f "$ROOT/zlib-1.3.1/libz$SUFFIX" ]]; then
        echo "libz$SUFFIX already exists, skipping zlib build."
        ZLIB_FOUND=1
        break
    fi
done

if [[ "$ZLIB_FOUND" -ne 1 ]]; then
    cd $ROOT/zlib-1.3.1
    $MAKE distclean
    chmod +x ./configure
    ./configure
    $MAKE
fi

# build libpng 1.6.17
for SUFFIX in "${LIB_SUFFIX[@]}"; do
    if [[ -f "$ROOT/libpng-1.6.17/libpng$SUFFIX" ]]; then
        echo "libpng$SUFFIX already exists, skipping zlib build."
        LIBPNG_FOUND=1
        break
    fi
done

if [[ "$LIBPNG_FOUND" -ne 1 ]]; then
    cd $ROOT/libpng-1.6.17
    $MAKE clean
    chmod +x ./configure
    ./configure --disable-shared --enable-static --with-zlib-prefix=$ROOT/zlib-1.3.1
    $MAKE
fi

# build pngquant
cd $ROOT
$MAKE clean
chmod +x $ROOT/configure
./configure --with-openmp ${SIMD_OPTION} --without-cocoa --without-lcms2 CC=${CC}
$MAKE

#!/usr/bin/env bash

set -e
set -x

if [ ! -d "depends/gmp/package_android_arm64" ]
then
    echo "Build GMP for android aarch64"
    ./build_gmp.sh android
fi

mkdir -p _build_android_arm64 && cd _build_android_arm64
cmake .. -DCMAKE_BUILD_TYPE=Debug -DUSE_ASM=Off -DTARGET_PLATFORM=android -DCMAKE_INSTALL_PREFIX="${PWD}/../package_android_arm64"
cmake --build . --target all -- -j 8
cmake --build . --target install

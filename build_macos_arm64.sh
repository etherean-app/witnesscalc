#!/usr/bin/env bash

set -e
set -x

if [ ! -d "depends/gmp/package_macos_arm64" ]
then
    echo "Build GMP for macos aarch64"
    ./build_gmp.sh macos_arm64
fi

mkdir -p _build_macos_arm64 && cd _build_macos_arm64
cmake .. -DCMAKE_BUILD_TYPE=Debug -DUSE_ASM=Off -DTARGET_PLATFORM=macos-aarch64 -DCMAKE_INSTALL_PREFIX="${PWD}/../package_macos_arm64"
cmake --build . --target all -- -j 8
cmake --build . --target install

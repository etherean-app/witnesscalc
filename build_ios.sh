#!/usr/bin/env bash

if [ ! -d "depends/gmp/package_ios_arm64" ]
then
    echo "Build GMP for iOS"
    ./build_gmp.sh ios
fi

mkdir -p _build_ios && cd _build_ios
cmake .. -DCMAKE_BUILD_TYPE=Debug -DUSE_ASM=Off -DTARGET_PLATFORM=ios -DCMAKE_INSTALL_PREFIX="${PWD}/../package_ios"
cmake --build . --target all -- -j 8
cmake --build . --target install

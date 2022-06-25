#!/bin/bash

cd /otbr/vcpkg/
git fetch
git pull

if [ -d "build" ]; then
        echo "Directory 'build' already exists, moving to it"
        cd /otbr/distro/build
        echo "Clean build directory"
        rm -rf *
        echo "Configuring"
        cmake -DCMAKE_TOOLCHAIN_FILE=/otbr/vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
else
        cd /otbr/distro/ && mkdir "build" && cd build
        cmake -DCMAKE_TOOLCHAIN_FILE=/otbr/vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
fi

cmake --build linux-release || exit 1
if [ $? -eq 1 ]; then
        echo "Compilation failed!"
else
        echo "Compilation successful!"
        cp /build/linux-release/bin/canary /otbr/system/
        chown otadmin:root /otbr/system/canary
fi

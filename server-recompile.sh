#!/bin/bash
arch=$(uname -i)
cd /otbr/vcpkg/
git fetch
git pull

if [ -d "/otbr/distro/build/" ]; then
        echo "Directory 'build' already exists, moving to it"
        cd /otbr/distro/build
        echo "Clean build directory"
        rm -rf *
        echo "Configuring"
        if  [[ $arch = aarch64 ]]; then
                export VCPKG_FORCE_SYSTEM_BINARIES=1
        fi
        cmake -DCMAKE_TOOLCHAIN_FILE=/otbr/vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
else
        cd /otbr/distro/ && mkdir "build" && cd build
        if  [[ $arch = aarch64 ]]; then
                export VCPKG_FORCE_SYSTEM_BINARIES=1
        fi
        cmake -DCMAKE_TOOLCHAIN_FILE=/otbr/vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
fi

cmake --build linux-release || exit 1
if [ $? -eq 1 ]; then
        echo "Compilation failed!"
else
        echo "Compilation successful!"
        cp /otbr/distro/build/linux-release/bin/canary /otbr/system/canary
        chown otadmin:root /otbr/system/canary
fi

#!/bin/bash

# enable common error handling options
set -o errexit
set -o nounset
set -o pipefail

export BAZELISK_VER=1.9.0
export ANKI_VER=2.1.41

## Install build dependencies
sudo dnf -y install rsync bash grep findutils curl gcc g++ git rust cargo nodejs
curl -L https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VER}/bazelisk-linux-arm64 -o ./bazel
chmod +x bazel && sudo mv bazel /usr/local/bin/

##Get Anki Source
# Github releases
#curl -L --output anki.tar.gz https://github.com/ankitects/anki/archive/refs/tags/${ANKI_VER}.tar.gz
#tar -xvf anki.tar.gz
#cd anki-${ANKI_VER}

# Master branch
git clone --depth=1 https://github.com/ankitects/anki
cd anki

##Apply patches
sed -i 's\github.com/ankitects/esbuild_toolchain/archive/refs/tags/anki-2021-04-15.tar.gz\https://github.com/qubist-pixel-ux/esbuild_toolchain/archive/refs/heads/toolchain.tar.gz\g' repos.bzl
sed -i 's\ac530f935b10e2e45f009ef0a8a2e3f4c95172c2548932fb7ca0d37ad95b6e9e\e4531f4fa0d49da22e480e4b8bc7a7591e0c864e6ea0142397cd7050077d9779\g' repos.bzl

##Use pyqt5 from distro
sudo dnf -y install python3-qt5-devel
echo "build --action_env=PYTHON_SITE_PACKAGES=/usr/lib64/python3.9/site-packages" >> user.bazelrc

##Build
./scripts/build

#!/bin/bash
export BAZELISK_VER=1.9.0
export ANKI_VER=2.1.44

## Install bazelisk
curl -L https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VER}/bazelisk-linux-arm64 -o ./bazel
chmod +x bazel && sudo mv bazel /usr/local/bin/

##Get Anki Source
curl -L --output anki.tar.gz https://github.com/ankitects/anki/archive/refs/tags/${ANKI_VER}.tar.gz
tar -xvf anki.tar.gz
cd anki-"${ANKI_VER}" || exit

##Use pyqt5 from distro
dnf -y install python3-qt5
cat "build --action_env=PYTHON_SITE_PACKAGES=/usr/lib64/python3.9/site-packages" >> user.bazelrc

##Build
./scripts/build

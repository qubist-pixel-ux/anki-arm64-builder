#!/bin/bash

# enable common error handling options
set -e

export BAZELISK_VER=1.9.0

apt update -y

## Setup Python
apt install -y python-is-python3

## Install build dependencies
apt -y install rsync bash grep findutils curl gcc g++ git rustc cargo nodejs
curl -L https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VER}/bazelisk-linux-arm64 -o ./bazel
chmod +x bazel && mv bazel /usr/local/bin/

##Get Anki Source
# Github releases
#curl -L --output anki.tar.gz https://github.com/ankitects/anki/archive/refs/tags/${ANKI_VER}.tar.gz
#tar -xvf anki.tar.gz
#cd anki-${ANKI_VER}

# Master branch
git clone --depth=1 https://github.com/ankitects/anki
cd anki

##Use pyqt5 from distro
apt -y install python3-pyqt5
echo "build --action_env=PYTHON_SITE_PACKAGES=/usr/lib/python3/dist-packages" >> user.bazelrc

##Build
#./scripts/build
rm -rf bazel-dist

## Build fails sometimes due to Bazel JS rules so run multiple times
count=0
until bazel build -k --config opt dist || (( count++ >= 10 )); do
  echo "Try ${count}"
done

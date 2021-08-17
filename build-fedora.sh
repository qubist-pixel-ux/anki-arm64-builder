#!/bin/bash

# enable common error handling options
set -e

export BAZELISK_VER=1.9.0

# Setup Python
ln -fs /usr/bin/python3 /usr/bin/python

## Install build dependencies
sudo dnf -y install rsync bash grep findutils curl gcc g++ git rust cargo nodejs
curl -L https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VER}/bazelisk-linux-arm64 -o ./bazel
chmod +x bazel && sudo mv bazel /usr/local/bin/

##Get Anki Source
# Github releases
curl -L --output anki.tar.gz https://github.com/ankitects/anki/archive/refs/tags/${ANKI_VER}.tar.gz
tar -xvf anki.tar.gz
cd anki-${ANKI_VER}

# Master branch
#git clone --depth=1 https://github.com/ankitects/anki
#cd anki

##Use pyqt5 from distro
sudo dnf -y install python3-qt5-devel
echo "build --action_env=PYTHON_SITE_PACKAGES=/usr/lib64/python3.9/site-packages" >> user.bazelrc

##Build
#./scripts/build
rm -rf bazel-dist

## Build fails sometimes due to Bazel JS rules so run multiple times
count=0
until bazel build -c opt --@io_bazel_rules_rust//worker:use_worker=False dist || (( count++ >= 10 )); do
  echo "Try ${count}"
done

#!/bin/sh -ex

export VERSION=`git describe --tags --abbrev=0`

# git clone https://git.ryujinx.app/kenji-nx/ryujinx.git
cd ryujinx
git checkout $VERSION

../windows/build.sh amd64
../windows/build.sh aarch64

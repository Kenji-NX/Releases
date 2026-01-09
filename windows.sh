#!/bin/sh +ex

export VERSION=`git describe --tags --abbrev=0`

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git
cd ryujinx || exit
git checkout $VERSION

../windows/build.sh x64
../windows/build.sh arm64

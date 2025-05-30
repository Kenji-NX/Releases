#!/bin/sh +ex

sudo add-apt-repository ppa:dotnet/backports
sudo apt-get update
sudo apt install -y zsync desktop-file-utils appstream dotnet-sdk-9.0

export VERSION=`git describe --tags --abbrev=0`

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git
cd ryujinx
git checkout $VERSION

../linux/appimage.sh x64
../linux/appimage.sh arm64

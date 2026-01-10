#!/bin/sh +ex

sudo add-apt-repository ppa:dotnet/backports
sudo apt-get update
sudo apt install -y desktop-file-utils appstream dotnet-sdk-10.0

VERSION=$(git describe --tags --abbrev=0)
export VERSION

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git
cd ryujinx || exit
git checkout $VERSION

../linux/appimage.sh x64
../linux/appimage.sh arm64

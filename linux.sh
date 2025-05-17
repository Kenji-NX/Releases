#!/bin/sh -ex

sudo add-apt-repository ppa:dotnet/backports
sudo apt-get update
sudo apt install -y zsync desktop-file-utils appstream dotnet-sdk-9.0

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git

cd ryujinx

../linux/appimage.sh amd64
../linux/appimage.sh aarch64

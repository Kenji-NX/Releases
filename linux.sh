#!/bin/sh
# sudo apt install -y zsync desktop-file-utils appstream

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git

cd ryujinx

../linux/appimage.sh amd64
../linux/appimage.sh aarch64

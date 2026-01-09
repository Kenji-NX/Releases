#!/bin/sh

export ARCH="$1"

if [ "$ARCH" = "" ]
then
    echo "Please specify an architecture (x64, arm64)"
    exit 1
fi

if [ "$ARCH" = "x64" ]; then
    export TARGET=linux-x64
elif [ "$ARCH" = "arm64" ]; then
    export TARGET=linux-arm64
else
    echo "Unexpected ARCH $ARCH. Supported architectures: x64, arm64"
    exit 1
fi

# TODO: nightly builds
export BUILDDIR=bin-$ARCH
export OUTDIR=../artifacts

rm -rf $BUILDDIR

dotnet publish src/Ryujinx -c Release -r $TARGET -p:DebugSymbols=false --self-contained -o $BUILDDIR

mkdir -p ../artifacts
cp -r $BUILDDIR ../artifacts/Ryujinx-$VERSION-$ARCH

mkdir -p tools
export PATH="$PATH:$(readlink -f tools)"

# Setup appimagetool
wget -q -O tools/appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x tools/appimagetool

## AppImage building ##

rm -rf AppDir
mkdir -p AppDir/usr/bin

cp distribution/linux/Ryujinx.desktop AppDir/Ryujinx.desktop
cp distribution/misc/Logo.png AppDir/Ryujinx.png
cp ../linux/AppRun AppDir

cp -r "$BUILDDIR"/* AppDir/usr/bin/

# Ensure necessary bins are set as executable
chmod +x AppDir/AppRun AppDir/usr/bin/Ryujinx*

mkdir -p "$OUTDIR"

appimagetool -n --comp zstd --mksquashfs-opt -Xcompression-level --mksquashfs-opt 21 \
    AppDir "$OUTDIR"/ryujinx-$VERSION-linux_$ARCH.AppImage

chmod a+x "$OUTDIR"/ryujinx-$VERSION-linux_$ARCH.AppImage
#!/bin/sh

export ARCH="$1"

if [ "$ARCH" = "" ]
then
    echo "Please specify an architecture (amd64, aarch64)"
    exit 1
fi

if [ "$ARCH" = "amd64" ]; then
    export TARGET=linux-x64
elif [ "$ARCH" = "aarch64" ]; then
    export TARGET=linux-arm64
else
    echo "Unexpected ARCH "$ARCH". Supported architectures: amd64, aarch64"
    exit 1
fi

# TODO: nightly builds
export BUILDDIR=bin-$ARCH
export OUTDIR=../artifacts

rm -rf $BUILDDIR

dotnet publish src/Ryujinx -c Release -r $TARGET -p:PublishSingleFile=true -p:DebugSymbols=false -o $BUILDDIR
mkdir -p tools
export PATH="$PATH:$(readlink -f tools)"

# Setup appimagetool
wget -q -O tools/appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x tools/appimagetool

export UFLAG="gh-releases-zsync|Kenji-NX|Releases|latest|*-$ARCH.AppImage.zsync"


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

appimagetool --comp zstd --mksquashfs-opt -Xcompression-level --mksquashfs-opt 21 \
    -u "$UFLAG" \
    AppDir "$OUTDIR"/Ryujinx-$VERSION-$ARCH.AppImage

# Move zsync file needed for delta updates
mv ./*.AppImage.zsync "$OUTDIR"

chmod a+x "$OUTDIR"/Ryujinx-$VERSION-$ARCH.AppImage
#!/bin/sh

export ARCH="$1"

if [ "$ARCH" = "" ]
then
    echo "Please specify an architecture (amd64, aarch64)"
    exit 1
fi

if [ "$ARCH" = "amd64" ]; then
    export TARGET=osx-x64
elif [ "$ARCH" = "aarch64" ]; then
    export TARGET=osx-arm64
else
    echo "Unexpected ARCH "$ARCH". Supported architectures: amd64, aarch64"
    exit 1
fi

# TODO: nightly builds
export BUILDDIR=bin-$ARCH
export OUTDIR=../artifacts
export VERSION=`git describe --tags --abbrev=0`

rm -rf $BUILDDIR

dotnet publish src/Ryujinx -c Release -r $TARGET -p:PublishSingleFile=true -p:DebugSymbols=false -o $BUILDDIR
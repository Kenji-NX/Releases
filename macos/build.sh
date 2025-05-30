#!/bin/sh

export ARCH="$1"

if [ "$ARCH" = "" ]
then
    echo "Please specify an architecture (x64, arm64)"
    exit 1
fi

if [ "$ARCH" = "x64" ]; then
    export TARGET=osx-x64
elif [ "$ARCH" = "arm64" ]; then
    export TARGET=osx-arm64
else
    echo "Unexpected ARCH "$ARCH". Supported architectures: x64, arm64"
    exit 1
fi

# TODO: nightly builds
export BUILDDIR=bin-$ARCH
export OUTDIR=../artifacts

rm -rf $BUILDDIR

dotnet publish src/Ryujinx -c Release -r $TARGET -p:PublishSingleFile=true -p:DebugSymbols=false -o $BUILDDIR
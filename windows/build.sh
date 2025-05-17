#!/bin/sh -ex

export ARCH="$1"

if [ "$ARCH" = "" ]
then
    echo "Please specify an architecture (amd64, aarch64)"
    exit 1
fi

if [ "$ARCH" = "amd64" ]; then
    export TARGET=win-x64
elif [ "$ARCH" = "aarch64" ]; then
    export TARGET=win-arm64
else
    echo "Unexpected ARCH "$ARCH". Supported architectures: amd64, aarch64"
    exit 1
fi

# TODO: nightly builds
export OUTDIR=../artifacts/Ryujinx-$VERSION-$ARCH

mkdir -p $OUTDIR

dotnet publish src/Ryujinx -c Release -r $TARGET -p:PublishSingleFile=true -p:DebugSymbols=false -o $OUTDIR
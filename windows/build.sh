#!/bin/sh -ex

export ARCH="$1"

if [ "$ARCH" = "" ]
then
    echo "Please specify an architecture (x64, arm64)"
    exit 1
fi

if [ "$ARCH" = "x64" ]; then
    export TARGET=win-x64
elif [ "$ARCH" = "arm64" ]; then
    export TARGET=win-arm64
else
    echo "Unexpected ARCH $ARCH. Supported architectures: x64, arm64"
    exit 1
fi

# TODO: nightly builds
export OUTDIR=../artifacts/Ryujinx-$VERSION-$ARCH

mkdir -p $OUTDIR

dotnet publish src/Ryujinx -c Release -r $TARGET -p:DebugSymbols=false --self-contained -o $OUTDIR
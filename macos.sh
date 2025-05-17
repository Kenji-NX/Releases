#!/bin/sh

set +e

export VERSION=`git describe --tags --abbrev=0`

brew install fd # dotnet-sdk

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git
cd ryujinx
git checkout $VERSION

../macos/build.sh amd64
../macos/build.sh aarch64

cd distribution/macos

./create_app_bundle.sh ../../bin-aarch64 app-aarch64 entitlements.xml
./create_app_bundle.sh ../../bin-amd64 app-amd64 entitlements.xml

mkdir -p Ryujinx.app/Contents/{Frameworks,MacOS}
cd app-aarch64

for file in `fd "Ryujinx$|dylib" Ryujinx.app -tf`
do
    # small hack to avoid lipo-ing universal dylibs
    FILEINFO=`file $file`
    # echo $FILEINFO
    if echo $FILEINFO | grep -q "with 2 architectures"
    then
        cp $file ../$file
    else
        echo $file
        echo $fileinfo
        lipo -create $file ../app-amd64/$file -output ../$file || cp $file ../$file
    fi
done

cp -r Ryujinx.app/Contents/{Info.plist,PkgInfo} ../Ryujinx.app/Contents/

cd ..
rm -rf ../../../artifacts/Ryujinx.app
cp -r Ryujinx.app/* ../../../artifacts/Ryujinx.app

cd ../../../
mkdir -p artifacts/Ryujinx.app/Contents/Resources
cp Ryujinx.icns artifacts/Ryujinx.app/Contents/Resources
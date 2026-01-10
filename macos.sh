#!/bin/sh

set +e

VERSION=$(git describe --tags --abbrev=0)
export VERSION

brew install fd # dotnet-sdk

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git
cd ryujinx || exit
git checkout $VERSION

../macos/build.sh x64
../macos/build.sh arm64

cd distribution/macos || exit

./create_app_bundle.sh ../../bin-arm64 app-arm64 entitlements.xml
./create_app_bundle.sh ../../bin-x64 app-x64 entitlements.xml

mkdir -p Ryujinx.app/Contents/{Frameworks,MacOS}
cd app-arm64 || exit

for file in $(fd "Ryujinx$|dylib" Ryujinx.app -tf)
do
    # small hack to avoid lipo-ing universal dylibs
    FILEINFO=$(file $file)
    # echo $FILEINFO
    if echo $FILEINFO | grep -q "with 2 architectures"
    then
        cp $file ../$file
    else
        echo $file
        echo $FILEINFO
        lipo -create $file ../app-x64/$file -output ../$file || cp $file ../$file
    fi
done

cp -r Ryujinx.app/Contents/{Info.plist,PkgInfo} ../Ryujinx.app/Contents/
cp -r Ryujinx.app/Contents/Resources/{Ryujinx.icns,Assets.car} ../Ryujinx.app/Contents/Resources/

cd ..
codesign --entitlements entitlements.xml -f --deep -s - Ryujinx.app
chmod u+x Ryujinx.app/Contents/MacOS/Ryujinx

cp -r Ryujinx.app ../../../artifacts/

cd ../../../artifacts || exit
zip -r Ryujinx.zip Ryujinx.app
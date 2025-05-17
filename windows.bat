@echo off

REM choco install dotnet-9.0-sdk

git clone https://git.ryujinx.app/kenji-nx/ryujinx.git

cd ryujinx

call ..\windows\build.bat win-arm64 aarch64
call ..\windows\build.bat win-x64 amd64
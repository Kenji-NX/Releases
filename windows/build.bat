@echo off

set target=%1
set arch=%2

REM TODO: nightly builds
set build_dir=bin-%arch%
set out_dir=..\artifacts

dotnet publish -c Release -r %target% -p:PublishSingleFile=true -p:DebugSymbols=false -o %build_dir%

cp -r %build_dir% %out_dir%\Ryujinx-Windows-%arch%
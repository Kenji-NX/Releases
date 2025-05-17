@echo off

set target=%1
set arch=%2

# TODO: nightly builds
set build_dir=bin-%arch%
set out_dir=..\artifacts

FOR /F "tokens=*" %a in ('git describe --tags --abbrev=0') do SET version=%a

dotnet publish -c Release -r %target% -p:PublishSingleFile=true -p:DebugSymbols=false -o %build_dir%

cp -r %build_dir% %out_dir%\Ryujinx-Windows-%version%-%arch%
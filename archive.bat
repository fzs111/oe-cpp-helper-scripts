@echo off

::set your neptun code here
set neptun=ABC123


set "hfno=%1"
set "version=%2"

if "%hfno%" == "" (
    set /p "hfno=Feladat number: "
    set /p "version=version: "
)

set "out=%neptun%_feladat%hfno%v%version%.zip"

if exist %out% (
    echo File already exists
    pause
)
::https://superuser.com/a/898508
tar -c -a -v -f %out% -C feladat%hfno% *.cpp *.h -C ../Unittest%hfno% Unittest1.cpp
if "%1"=="" pause
@echo off
echo -----------------------------------
echo             P R O T O N            
echo -----------------------------------
echo by Krzysztof Palaiologos Szewczyk
echo Copyright (C) 2019, licensed under
echo terms of GPLv3 license.
echo.

mkdir tmp 2> nul

if "%1"=="" (
    echo Usage: proton file.swf [icon.ico]
    goto end
)

copy %1 tmp\app.swf > nul
copy data\projector.exe tmp\projector.exe > nul

if not "%2"=="" (
    tools\rcedit tmp\projector.exe --set-icon %2 2>nul
)

tools\7z a tmp\arc.7z tmp\app.swf tmp\projector.exe

copy /b data\x86-mod.sfx + data\header.txt + tmp\arc.7z tmp\app.exe

if not "%2"=="" (
    tools\rh -open tmp\app.exe -save tmp\new.exe -action addoverwrite -res %2 -mask ICONGROUP,MAINICON,
    del tmp\app.exe 2> nul
    copy tmp\new.exe tmp\app.exe 2> nul
    del tmp\new.exe 2> nul
)

copy tmp\app.exe app.exe

cd tmp
del app.exe 2> nul
del new.exe 2> nul
del app.swf 2> nul
del arc.7z 2> nul
del icon.ico 2> nul
del projector.exe 2> nul
cd ..

echo Done!

:end

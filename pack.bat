
echo -----------------------------------
echo             P R O T O N            
echo -----------------------------------
echo by Krzysztof Palaiologos Szewczyk
echo Copyright (C) 2019, licensed under
echo terms of GPLv3 license.
echo.

mkdir dist
mkdir tmp

if "%1"=="" (
    goto end
)

copy %1 tmp\app.swf
copy data\projector.exe tmp\projector.exe
copy data\title.exe tmp\title.exe
copy config.ini tmp\config.ini

if not "%2"=="" (
    tools\rcedit tmp\projector.exe --set-icon %2 2>nul
)

cd tmp
..\tools\7z a arc.7z app.swf title.exe projector.exe config.ini
cd..

copy /b data\x86-mod.sfx + data\header.txt + tmp\arc.7z tmp\app.exe

if not "%2"=="" (
    tools\rh -open tmp\app.exe -save tmp\new.exe -action addoverwrite -res %2 -mask ICONGROUP,MAINICON,
    del tmp\app.exe
    copy tmp\new.exe tmp\app.exe
    del tmp\new.exe
)

copy tmp\app.exe dist\app.exe

cd tmp
del app.exe 2> nul
del new.exe 2> nul
del app.swf 2> nul
del arc.7z 2> nul
del icon.ico 2> nul
del projector.exe 2> nul
del title.exe 2> nul
del config.ini 2> nul
cd ..

echo Done!

:end

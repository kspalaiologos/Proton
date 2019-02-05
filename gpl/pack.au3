
; 
; This file is part of the Proton distribution (https://github.com/KrzysztofSzewczyk/Proton).
; Copyright (c) 2019 Krzysztof Palaiologos Szewczyk.
; 
; This program is free software: you can redistribute it and/or modify  
; it under the terms of the GNU General Public License as published by  
; the Free Software Foundation, version 3.
; 
; This program is distributed in the hope that it will be useful, but 
; WITHOUT ANY WARRANTY; without even the implied warranty of 
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
; General Public License for more details.
; 
; You should have received a copy of the GNU General Public License 
; along with this program. If not, see <http://www.gnu.org/licenses/>.
; 

#NoTrayIcon
#AutoIt3Wrapper_Change2CUI=y

#include <AutoItConstants.au3>
#include <Date.au3>

ConsoleWrite("-----------------------------------" & @CRLF);
ConsoleWrite("            P R O T O N            " & @CRLF);
ConsoleWrite("-----------------------------------" & @CRLF);
ConsoleWrite("by Krzysztof Palaiologos Szewczyk" & @CRLF);
ConsoleWrite("Copyright (C) 2019, licensed under" & @CRLF);
ConsoleWrite("terms of GPLv3 license." & @CRLF);
ConsoleWrite(@CRLF);

ConsoleWrite("> Creating directories ..." & @CRLF);

func SafeDirCreate($name)
    if not FileExists($name) then
        if DirCreate($name) == 0 then
            ConsoleWrite("Creating " & $name & ": failed!" & @CRLF);
            exit;
        endif
    else
        ConsoleWrite($name & " already exists, skipping." & @CRLF);
    endif
endfunc

func SafeCopy($src, $dest)
    if not FileExists($dest) then
        if FileCopy($src, $dest) == 0 then
            ConsoleWrite("Copying " & $src & " => " & $dest & ": failed!" & @CRLF);
            Cleanup()
            exit;
        endif
    else
        ConsoleWrite($src & " already exists, skipping." & @CRLF);
    endif
endfunc

func SafeExists($src)
    if not FileExists($src) then
        ConsoleWrite($src & " : File not found!" & @CRLF);
        Cleanup()
        exit;
    endif
endfunc

func Cleanup()
    if DirRemove("tmp", $DIR_REMOVE) == 0 then
        ConsoleWrite("Cleanup failed.")
        exit
    endif
endfunc

FileChangeDir(@ScriptDir)

SafeDirCreate("dist")
SafeDirCreate("tmp")

if $CmdLine[0] < 1 then
    ConsoleWrite("Usage: pack file.swf [icon.ico]")
    exit
endif

SafeExists("src\" & $CmdLine[1])

ConsoleWrite("> Copying files ..." & @CRLF);

SafeCopy("src\" & $CmdLine[1], "tmp\app.swf")
SafeCopy("data\projector.exe", "tmp\projector.exe")
SafeCopy("data\title.exe", "tmp\title.exe")
SafeCopy("config.ini", "tmp\config.ini")

ConsoleWrite("> Updating resources 1/2 ..." & @CRLF);

if $CmdLine[0] == 2 then
    SafeExists($CmdLine[2])
    RunWait("tools\rcedit tmp\projector.exe --set-icon " & $CmdLine[2])
endif

ConsoleWrite("> Packing ..." & @CRLF);

RunWait("tools\7z a arc.7z app.swf title.exe projector.exe config.ini", "tmp")

ConsoleWrite("> Merging ..." & @CRLF);

RunWait(@ComSpec & " /c " & "copy /b data\x86-mod.sfx + data\header.txt + tmp\arc.7z tmp\app.exe")

ConsoleWrite("> Updating resources 2/2 ..." & @CRLF);

if $CmdLine[0] == 2 then
    RunWait("tools\rh -open tmp\app.exe -save tmp\new.exe -action addoverwrite -res " & $CmdLine[2] & " -mask ICONGROUP,MAINICON,")
    if FileDelete("tmp\app.exe") == 0 then
        ConsoleWrite("Resource manipulation failed (I).")
        Cleanup()
        exit
    endif
    
    if FileMove("tmp\new.exe", "tmp\app.exe") == 0 then
        ConsoleWrite("Resource manipulation failed (II).")
        Cleanup()
        exit
    endif
endif

ConsoleWrite("> Finishing ..." & @CRLF);

SafeCopy("tmp\app.exe", "dist\appv" & @MDAY & "-" & @MON & "-" & @YEAR & "_"  & @HOUR & "-" & @MIN & "-" & @SEC & ".exe")

if FileDelete("tmp\app.exe") == 0 then
    ConsoleWrite("Resource manipulation failed (III).")
    Cleanup()
    exit
endif

ConsoleWrite("> Cleaning up ..." & @CRLF);

Cleanup()

ConsoleWrite("> Done!" & @CRLF);

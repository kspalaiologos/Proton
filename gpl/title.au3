
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

Func WinHandFromPID($pid, $winTitle="", $timeout=8)
    Local $secs = 0
    Do
        $wins = WinList($winTitle)
        For $i = 1 To UBound($wins)-1
            If (WinGetProcess($wins[$i][1]) == $pid) Then Return $wins[$i][1]
        Next
        Sleep(100)
        $secs += 0.1
    Until $secs == $timeout
EndFunc

Local $pid = Run("projector.exe app.swf")
Local $hWnd = WinHandFromPID($pid, "Adobe Flash Player 27", 100)
Local $title = IniRead("config.ini", "General", "Title", "A Proton Application");
WinSetTitle($hWnd, "Adobe Flash Player 27", $title)

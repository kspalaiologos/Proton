
; Script executing Flash projector and changing it's title.
; To be improved.

; Copyright (C) by Krzysztof Palaiologos Szewczyk, 2019, licensed under terms of GPLv3 license.

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


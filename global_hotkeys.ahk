; ^ ctrl
; ! alt
; + shift
; # win









F13_Count := [3,3]
F14_onoff := [0,0]

curDesktop  := 2

;keys := ["^!v", "^!b", "^!n", "^!f"]
keys := ["^!v", "^!n", "^!f"]


F13:: {
    global F14_onoff, F13_Count, curDesktop, keys

    F13_Count[curDesktop] := Mod(F13_Count[curDesktop] - F14_onoff[curDesktop], keys.Length) + 1
    F14_onoff[curDesktop] := 0

    keyToSend := keys[F13_Count[curDesktop]]
    Send(keyToSend)
}


F14:: {
    global F14_onoff, F13_Count, curDesktop, keys

    if (Mod(F14_onoff[curDesktop], 2) = 0) {
        Send("^!p")
    } else {
        keyToSend := keys[F13_Count[curDesktop]]
        Send(keyToSend)
    }

    F14_onoff[curDesktop] := Mod(F14_onoff[curDesktop] + 1, 2)
}









; Define the class name for Adobe Acrobat Reader
acrobatClass := "AcrobatSDIWindow"

; F15 Hotkey
F15:: {
    ; Retrieve the HWND of the active window
    hwnd := WinGetID("A")
    if !hwnd {
        ;MsgBox("No active window found.")
        return
    }

    ; Retrieve the class name of the active window
    activeWindowClass := WinGetClass(hwnd)

    if (activeWindowClass = acrobatClass) {
        ; If the active window is Adobe Acrobat Reader, click its tab and send Ctrl+Alt+1
        ; ClickAcrobatTab(hwnd)
        Send("^!1")
    } else {
        ; If the active window is not Adobe Acrobat Reader, send Ctrl+Alt+1
        Send("^!1")
    }
}

; F16 Hotkey
F16:: {
    ; Retrieve the HWND of the active window
    hwnd := WinGetID("A")
    if !hwnd {
        MsgBox("No active window found.")
        return
    }

    ; Retrieve the class name of the active window
    activeWindowClass := WinGetClass(hwnd)

    if (activeWindowClass = acrobatClass) {
        ; If the active window is Adobe Acrobat Reader, click its tab and send Ctrl+Alt+2
        ; ClickAcrobatTab(hwnd)
        Send("^!2")
    } else {
        ; If the active window is not Adobe Acrobat Reader, send Ctrl+Alt+2
        Send("^!2")
    }
}

; Function to click the Acrobat Reader's tab
ClickAcrobatTab(hwnd) {
    ; Retrieve the position of the specified window
    WinGetPos(&winX, &winY, &winWidth, &winHeight, hwnd)

    ; Calculate the coordinates to click (adjust as necessary)
    clickX := winX + 600  ; Example offset; adjust based on actual tab position
    clickY := winY + 10  ; Example offset; adjust based on actual tab position

    ; Save the current mouse position
    MouseGetPos(&originalX, &originalY)

    ; Move the mouse to the calculated position and click
    MouseMove(clickX, clickY)
    Click("left")

    ; Return the mouse to its original position
    ;MouseMove(originalX, originalY)
}













F17_Count := 0
F17:: {
    global F17_Count
    togg_pen_scroll := ["^+a","^+e","^+p"]
    keyToSend := togg_pen_scroll[F17_Count + 1]
    Send(keyToSend)
    F17_Count := Mod(F17_Count + 1, 3)
}



F18:: {
    Send("{Alt down}{Tab}")
}

F18 up:: {
    Send("{Alt up}")
}



F19:: {
    global F14_onoff, F13_Count, curDesktop
    movedesk := ["^#{Right}", "^#{Left}"]
    curDesktop := 3 - curDesktop
    if (Mod(F14_onoff[curDesktop], 2) = 1) {
        Send("^!p")
        Sleep(300)
    } else {
        keyToSend := keys[F13_Count[curDesktop]]
        Send(keyToSend)
    }
    Send(movedesk[3 - curDesktop])
}








F22_Count := 0
F22:: {
    global F22_Count
    switch F22_Count {
        case 0:
            Send("^!w")
        case 1:
            Send("^!x")
        case 2:
            WinMaximize("A")
    }
    F22_Count := Mod(F22_Count + 1, 3)
}



F23:: {
    ScrollAdobeReader("up")
}

F24:: {
    ScrollAdobeReader("down")
}

ScrollAdobeReader(direction) {
    MouseGetPos &originalX, &originalY

    if WinExist("ahk_class AcrobatSDIWindow") {
        WinGetPos &winX, &winY, &winWidth, &winHeight

        centerX := winX + winWidth // 2
        centerY := winY + winHeight // 2

        ;DllCall("SetCursorPos", "int", centerX, "int", centerY)
        MouseMove(centerX, centerY)

        if (direction = "down") {
            Send("{WheelDown}")
        } else if (direction = "up") {
            Send("{WheelUp}")
        }

        ;DllCall("SetCursorPos", "int", originalX, "int", originalY)
        MouseMove(originalX, originalY)
    } else {
        MsgBox("Adobe Reader window not found.")
    }
}





































Toggle := 0
BlackScreen1 := 0
BlackScreen3 := 0 

^!o:: {
    global Toggle, BlackScreen1, BlackScreen3
    Toggle := Toggle ?? 0
    Toggle := !Toggle
    if Toggle {
        ; Create a black GUI window for the first monitor (left of primary)
        BlackScreen1 := Gui()
        BlackScreen1.BackColor := "Black"
        BlackScreen1.Opt("-Caption +ToolWindow +AlwaysOnTop")
        ; Position the GUI on the first monitor
        BlackScreen1.Show("x-1920 y0 w1920 h1080")

        ; Create a black GUI window for the third monitor (right of primary)
        BlackScreen3 := Gui()
        BlackScreen3.BackColor := "Black"
        BlackScreen3.Opt("-Caption +ToolWindow +AlwaysOnTop")
        ; Position the GUI on the third monitor
        BlackScreen3.Show("x1920 y-851 w1200 h1920")
    } else {
        ; Close the GUI windows
        BlackScreen1.Destroy()
        BlackScreen3.Destroy()
    }
}




; Define the paths and device names
nircmdPath := "C:\NirCmd\nircmd.exe"
device1 := "BenQ EX3200R"
device2 := "WH-1000XM3"
volumeLevel := 6553*1

; Initialize the toggle state
currentDevice := ""

; Define the hotkey for toggling devices
!+d:: {
    global currentDevice, device1, device2
    if (currentDevice = device1) {
        nextDevice := device2
    } else {
        nextDevice := device1
    }
    
    RunWait(nircmdPath . ' setdefaultsounddevice "' . nextDevice . '"')
    if (nextDevice = device2) {
        RunWait(nircmdPath . ' setsysvolume "' . volumeLevel * 3 . '"')
    } else if (nextDevice = device1) {
        RunWait(nircmdPath . ' setsysvolume "' . volumeLevel * 7 . '"')
    }
    
    currentDevice := nextDevice
    TrayTip("Audio Device Switched", "Default audio device set to: " . nextDevice)
}
!+a:: {
    currentPercent := SoundGetVolume()
    
    currentNir := Round(currentPercent * 65535 / 100)
    
    newNir := currentNir - volumeLevel
    if (newNir < 0)
        newNir := 0
    
    Run('"' . nircmdPath . '" setsysvolume ' . newNir)
    ;TrayTip("Audio Volume Changed", "Audio volume set to: " . Round(newNir * 100 / 65535))    
}
!+s:: {
    currentPercent := SoundGetVolume()
    SoundSetMute(false)
    
    currentNir := Round(currentPercent * 65535 / 100)
    
    newNir := currentNir + volumeLevel
    if (newNir > 65535)
        newNir := 65535

    Run('"' . nircmdPath . '" setsysvolume ' . newNir)
    ;TrayTip("Audio Volume Changed", "Audio volume set to: " . Round(newNir * 100 / 65535))  
}



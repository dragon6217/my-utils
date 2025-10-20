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


















































































































































; 폐기


; #Requires AutoHotkey v2.0

; numDesktops := 2
; DesktopCount := 2
; CurrentDesktop := 1

; pdfWin := "ahk_exe AcroRd32.exe"
; pdfWin := "ahk_exe Acrobat.exe"


/* ; old version
F13::
    keys := ["^!v", "^!b", "^!n", "^!f"]
    Send, % keys[Mod(F13_Count[curDesktop] + (4 - F14_count[curDesktop]), 4) + 1]
    F13_Count[curDesktop] := Mod(F13_Count[curDesktop] + (4 - F14_count[curDesktop]) + 1, 4)    
    F14_count[curDesktop] := 0
return

F14::
    if (Mod(F14_Count[curDesktop], 2) = 0) {
        Send, ^!p
    } else {
        keys := ["^!f", "^!v", "^!b", "^!n"]
        Send, % keys[F13_Count[curDesktop] + 1]
    }
    F14_Count[curDesktop] := Mod(F14_Count[curDesktop] + 1, 2)
return
*/

/*
F13_Count := [4,4]
F14_Count := [0,0]


F13:: {
    global F14_Count, F13_Count, curDesktop
    keys := ["^!v", "^!b", "^!n", "^!f"]
    keyToSend := keys[Mod(F13_Count[curDesktop] + (4 - F14_Count[curDesktop]), 4) + 1]
    Send(keyToSend)
    F13_Count[curDesktop] := Mod(F13_Count[curDesktop] + (4 - F14_Count[curDesktop]) + 1, 4)
    F14_Count[curDesktop] := 0
}

F14:: {
    global F14_Count, F13_Count, curDesktop
    if (Mod(F14_Count[curDesktop], 2) = 0) {
        Send("^!p")
    } else {
        keys := ["^!f", "^!v", "^!b", "^!n"]
        keyToSend := keys[F13_Count[curDesktop] + 1]
        Send(keyToSend)
    }
    F14_Count[curDesktop] := Mod(F14_Count[curDesktop] + 1, 2)
}
*/




/* 폐기, 한쪽씩 보기 <-> 두쪽씩 보기
F14::{
if (F14_Count = 0) {
    Send, !f
    Sleep, delay
    Send, w
    Sleep, delay
    Send, i
    Sleep, delay
    Send, s
} Else If (F14_Count = 1) {
    Send, !f
    Sleep, delay
    Send, w
    Sleep, delay
    Send, i
    Sleep, delay
    Send, p
}
F14_Count := Mod(F14_Count + 1, 2)  
return
}
*/





/*
F16::
    ; 현재 활성 창의 핸들 가져오기
    WinGet, activeHwnd, ID, A

    ; MONITOR_DEFAULTTONEAREST (값 2)로 모니터 핸들 얻기
    hMonitor := DllCall("MonitorFromWindow", "Ptr", activeHwnd, "UInt", 2, "Ptr")
    
    ; MONITORINFO 구조체 (40바이트) 준비
    VarSetCapacity(mi, 40, 0)
    NumPut(40, mi, 0, "UInt")
    
    if (!DllCall("GetMonitorInfo", "Ptr", hMonitor, "Ptr", &mi))
    {
        MsgBox, 모니터 정보를 가져오지 못했습니다.
        Return
    }
    
    ; 모니터의 왼쪽 좌표를 확인하여 현재 모니터 판단
    monLeft := NumGet(mi, 4, "Int")
    
    if (monLeft >= 0 and monLeft < 2000) {
        ; 모니터 B: 지정 좌표 (960, 17), ctrl+alt+2 입력
        MouseMove, 960, 17, 0
        Sleep, 50
        Click
        Sleep, 50
        Send, ^!2
    } else if (monLeft >= 2000) {
        ; 모니터 C: 지정 좌표 (2150, -830), ctrl+alt+1 입력
        MouseMove, 2150, -830, 0
        Sleep, 50
        Click
        Sleep, 50
        Send, ^!1
    } else {
        ; 모니터 A의 경우 별도의 동작이 없으면 그냥 종료하거나 메시지를 표시할 수 있음
        MsgBox, 현재 활성 창이 모니터 A에 있습니다.
    }
Return
*/

/*
; Assign F16 to send Ctrl+Alt+1 or Ctrl+Alt+2 based on Adobe Reader's monitor
F16:: {
    ; Define constants for monitor positions
    LEFT_MONITOR := 2
    RIGHT_MONITOR := 3

    ; Attempt to find the Adobe Reader window
    if WinExist("ahk_class AcrobatSDIWindow") {
        ; Get the position and size of the Adobe Reader window
        WinGetPos(&winX, &winY, &winWidth, &winHeight)

        ; Calculate the center position of the Adobe Reader window
        winCenterX := winX + (winWidth / 2)
        winCenterY := winY + (winHeight / 2)

        ; Determine which monitor the window's center is on
        monitor := GetMonitorFromPoint(winCenterX, winCenterY)

        ; Send the appropriate keystroke based on the monitor
        if (monitor = RIGHT_MONITOR) {
            Send("^!1")
        } else if (monitor = LEFT_MONITOR) {
            Send("^!2")
        } else {
            MsgBox("Adobe Reader is not on the left or right monitor.")
        }
    } else {
        MsgBox("Adobe Reader window not found.")
    }
}

; Function to determine which monitor a point is on
GetMonitorFromPoint(x, y) {
    ; Retrieve the number of monitors
    monitorCount := MonitorGetCount()

    ; Iterate through each monitor
    Loop monitorCount {
        ; Get monitor work area
        try {
            MonitorGet(A_Index, &monitorLeft, &monitorTop, &monitorRight, &monitorBottom)
        } catch {
            continue
        }

        ; Check if the point is within the monitor's bounds
        if (x >= monitorLeft && x <= monitorRight && y >= monitorTop && y <= monitorBottom) {
            return A_Index
        }
    }
    return 0 ; Point is not on any known monitor
}
*/




/*
F18::
    Send, {Alt down}{Tab}
Return

F18 up::
    Send, {Alt up}
Return
*/

/*
F18::
    Send {Alt down}{Tab}
    Sleep 100
    Send {Alt up}
return
*/





/* F19 에 대한 내용 이었으나 폐기
; Function to retrieve the current virtual desktop ID
getCurrentDesktopId() {
    SessionId := DllCall("GetCurrentProcessId", "UInt")
    RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
    return CurrentDesktopId
}

; Function to map desktops from the registry
mapDesktopsFromRegistry() {
    CurrentDesktopId := getCurrentDesktopId()
    RegRead, DesktopList, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        IdLength := StrLen(CurrentDesktopId)
        DesktopCount := StrLen(DesktopList) / IdLength
        Loop, %DesktopCount% {
            If (SubStr(DesktopList, ((A_Index - 1) * IdLength) + 1, IdLength) = CurrentDesktopId) {
                CurrentDesktop := A_Index
                break
            }
        }
    } else {
        DesktopCount := 2
        CurrentDesktop := 1
    }
}

F19::
KeyWait, F19
mapDesktopsFromRegistry()
if (CurrentDesktop = 1) {
    Send, ^#{Right}
} else {
    Send, ^#{Left}
}
return
*/


/*
F19::
    movedesk := ["^#{Right}","^#{Left}"]
    curDesktop := 3 - curDesktop      
    if (Mod(F14_Count[curDesktop], 2) = 1) {
        Send, ^!p
        Sleep 300
    } else {
        keys := ["^!f", "^!v", "^!b", "^!n"]
        Send, % keys[F13_Count[curDesktop] + 1]
    }
    Send, % movedesk[3 - curDesktop]
      
return
*/





/* 실험용, 폐기
F20::
    Send, {Ctrl down}  ; Ctrl 키 누르기
    Send, w            ; 'w' 키 입력
    Send, {Ctrl up}    ; Ctrl 키 떼기
return
*/

/*
F??:: {
    ; Get active window position and dimensions.
    pos := WinGetPos("A")
    CenterX := pos.x + (pos.w // 2)
    CenterY := pos.y + (pos.h // 2)

    ; Retrieve monitor work area objects for monitor 2 (middle) and monitor 3 (right)
    mon2 := SysGet("MonitorWorkArea", 2)
    mon3 := SysGet("MonitorWorkArea", 3)

    if (CenterX >= mon2.Left && CenterX <= mon2.Right && CenterY >= mon2.Top && CenterY <= mon2.Bottom) {
        ; Send Ctrl+Alt+2 if the window is on the middle monitor.
        Send "^!2"
    } else if (CenterX >= mon3.Left && CenterX <= mon3.Right && CenterY >= mon3.Top && CenterY <= mon3.Bottom) {
        ; Send Ctrl+Alt+1 if the window is on the right monitor.
        Send "^!1"
    }
}
*/





/*
F21::
    switch F21_Count
    {
        case 0:
            Send, ^!w
        case 1:
            WinMaximize, A
    }
    F22_Count := 0    
    F21_Count := Mod(F21_Count + 1, 2)    
return

F22::
    switch F22_Count
    {
        case 0:
            Send, ^!x
        case 1:
            WinMaximize, A
            F21_Count := 0
    }
    F21_Count := 0    
    F22_Count := Mod(F22_Count + 1, 2)    
return
*/

/*
F21:: {
    global F21_Count
    switch F21_Count {
        case 0:
            Send("^!w")
        case 1:
            WinMaximize("A")
    }
    F22_Count := 0
    F21_Count := Mod(F21_Count + 1, 2)
}

F22:: {
    global F22_Count
    switch F22_Count {
        case 0:
            Send("^!x")
        case 1:
            WinMaximize("A")
            F21_Count := 0
    }
    F21_Count := 0
    F22_Count := Mod(F22_Count + 1, 2)
}
*/




/*
F23::
    ; 현재 활성 창의 핸들 가져오기
    WinGet, activeHwnd, ID, A

    ; MONITOR_DEFAULTTONEAREST (값 2)로 모니터 핸들 얻기
    hMonitor := DllCall("MonitorFromWindow", "Ptr", activeHwnd, "UInt", 2, "Ptr")
    
    ; MONITORINFO 구조체 (40바이트) 준비
    VarSetCapacity(mi, 40, 0)
    NumPut(40, mi, 0, "UInt")
    
    if (!DllCall("GetMonitorInfo", "Ptr", hMonitor, "Ptr", &mi))
    {
        MsgBox, 모니터 정보를 가져오지 못했습니다.
        Return
    }
    
    ; 모니터의 왼쪽 좌표 가져오기
    monLeft := NumGet(mi, 4, "Int")
    
    ; monLeft 값에 따라 미리 지정한 좌표로 이동 (모니터 A, B, C)
    if (monLeft < 0) {
        centerX := -920
        centerY := 550
    } else if (monLeft < 2000) {  ; 모니터 B (예: 0 이상 ~ 2000 미만)
        centerX := 980
        centerY := 520
    } else {  ; 모니터 C (2000 이상)
        centerX := 2550
        centerY := 100
    }
    
    ; 마우스 커서를 지정된 좌표로 이동 후 휠 올리기
    MouseMove, centerX, centerY, 0
    Sleep, 50
    Send, {WheelUp}
Return

F24::
    WinGet, activeHwnd, ID, A
    hMonitor := DllCall("MonitorFromWindow", "Ptr", activeHwnd, "UInt", 2, "Ptr")
    VarSetCapacity(mi, 40, 0)
    NumPut(40, mi, 0, "UInt")
    
    if (!DllCall("GetMonitorInfo", "Ptr", hMonitor, "Ptr", &mi))
    {
        MsgBox, 모니터 정보를 가져오지 못했습니다.
        Return
    }
    
    monLeft := NumGet(mi, 4, "Int")
    
    if (monLeft < 0) {
        centerX := -920
        centerY := 550
    } else if (monLeft < 2000) {
        centerX := 980
        centerY := 520
    } else {
        centerX := 2550
        centerY := 100
    }
    
    MouseMove, centerX, centerY, 0
    Sleep, 50
    Send, {WheelDown}
Return
*/





/*
; Define hotkey to toggle black screens
^!o::
Toggle := !Toggle
If Toggle
{
    ; Create a black GUI window for the first monitor (left of primary)
    Gui, BlackScreen1: Color, Black
    Gui, BlackScreen1: -Caption +ToolWindow +AlwaysOnTop
    ; Position the GUI on the first monitor
    Gui, BlackScreen1: Show, x-1920 y0 w1920 h1080

    ; Create a black GUI window for the third monitor (right of primary)
    Gui, BlackScreen3: Color, Black
    Gui, BlackScreen3: -Caption +ToolWindow +AlwaysOnTop
    ; Position the GUI on the third monitor
    Gui, BlackScreen3: Show, x1920 y-851 w1200 h1920
}
Else
{
    ; Close the GUI windows
    Gui, BlackScreen1: Destroy
    Gui, BlackScreen3: Destroy
}
Return
*/



/*
!+a:: {
    currentVolume := SoundGetVolume()
    newVolume := Max(currentVolume - 20, 0)
    SoundSetVolume(newVolume)
    if (newVolume < 5) {
        SoundSetMute(true)
        SoundSetVolume(1)
    }
}
!+s:: {
    currentVolume := SoundGetVolume()
    if (SoundGetMute() && currentVolume < 5) {
        newVolume := 20
        SoundSetVolume(newVolume)
        SoundSetMute(false)
    } else {
        newVolume := Min(currentVolume + 20, 100)
        SoundSetVolume(newVolume)
        SoundSetMute(false)
    }
}
*/



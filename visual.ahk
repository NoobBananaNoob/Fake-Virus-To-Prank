#NoEnv
SetBatchLines, -1
#Persistent
CoordMode, Screen

; === Settings ===
whiteFlashDuration := 250
blackFlashDuration := 250
normalDuration := 100
flashIconSpawnInterval := 100
alwaysIconSpawnInterval := 200
invertDelay := 150  ; Interval to toggle NegativeScreen
iconSize := 32
iconFolder := A_ScriptDir . "\"
exePath := iconFolder . "NegativeScreen.exe"

; List of icons
iconPaths := []
iconPaths.push(iconFolder . "warn.ico")
iconPaths.push(iconFolder . "shield.ico")
iconPaths.push(iconFolder . "net.ico")
iconPaths.push(iconFolder . "info.ico")

state := 0

ToolTip, Never Trust Them, 100, 200
Sleep 2000

; === Flash GUI setup ===
Gui, FlashOverlay:New, +AlwaysOnTop -Caption +ToolWindow -E0x20
Gui, FlashOverlay:Color, White
Gui, FlashOverlay:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate

SetTimer, FlashCycle, %normalDuration%

; Start timers for icons
SetTimer, SpawnIcon_1, %alwaysIconSpawnInterval%
SetTimer, SpawnIcon_2, %alwaysIconSpawnInterval%
SetTimer, SpawnIcon_3, %alwaysIconSpawnInterval%
SetTimer, SpawnIcon_4, %alwaysIconSpawnInterval%

; === Start NegativeScreen.exe and wait ===
Run, %exePath%, , Hide
Sleep 500  ; Give it time to load

; === Set toggle timer (simulate Ctrl+Alt+N every 150ms) ===
SetTimer, ToggleInvert, %invertDelay%

ToggleInvert:
    Send ^!n  ; Replace this with the correct hotkey combo if different
Return

; === Flash logic ===
FlashCycle:
    if (state = 0) {
        Gui, FlashOverlay: +AlwaysOnTop -Caption +ToolWindow -E0x20
        Gui, FlashOverlay:Color, White
        Gui, FlashOverlay:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate
        SetTimer, SpawnErrorIcons, %flashIconSpawnInterval%
        state := 1
        SetTimer, FlashCycle, -%whiteFlashDuration%
    } 
    else if (state = 1) {
        Gui, FlashOverlay:Hide
        SetTimer, SpawnErrorIcons, Off
        state := 2
        SetTimer, FlashCycle, -%normalDuration%
    }
    else if (state = 2) {
        Gui, FlashOverlay: +AlwaysOnTop -Caption +ToolWindow -E0x20
        Gui, FlashOverlay:Color, Black
        Gui, FlashOverlay:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate
        SetTimer, SpawnErrorIcons, %flashIconSpawnInterval%
        state := 3
        SetTimer, FlashCycle, -%blackFlashDuration%
    }
    else if (state = 3) {
        Gui, FlashOverlay:Hide
        SetTimer, SpawnErrorIcons, Off
        state := 0
        SetTimer, FlashCycle, -%normalDuration%
    }
Return

SpawnErrorIcons:
    SpawnOneIcon(iconFolder . "error.ico")
Return

SpawnIcon_1:
    SpawnOneIcon(iconPaths[1])
Return
SpawnIcon_2:
    SpawnOneIcon(iconPaths[2])
Return
SpawnIcon_3:
    SpawnOneIcon(iconPaths[3])
Return
SpawnIcon_4:
    SpawnOneIcon(iconPaths[4])
Return

SpawnOneIcon(iconPath) {
    global iconSize
    Random, x, 0, % A_ScreenWidth - iconSize
    Random, y, 0, % A_ScreenHeight - iconSize

    guiName := "Icon" . A_TickCount
    Gui, %guiName%:New, +AlwaysOnTop -Caption +ToolWindow +LastFound +E0x20
    Gui, %guiName%:Add, Picture, x0 y0 w%iconSize% h%iconSize%, %iconPath%
    Gui, %guiName%:Show, x%x% y%y% NoActivate
}

; === Emergency Exit + Kill Inversion ===
Esc::
    SetTimer, FlashCycle, Off
    SetTimer, SpawnErrorIcons, Off
    SetTimer, SpawnIcon_1, Off
    SetTimer, SpawnIcon_2, Off
    SetTimer, SpawnIcon_3, Off
    SetTimer, SpawnIcon_4, Off
    SetTimer, ToggleInvert, Off

    Gui, FlashOverlay:Destroy
    WinGet, idList, List, ahk_class AutoHotkeyGUI
    Loop %idList%
    {
        this_id := idList%A_Index%
        WinClose, ahk_id %this_id%
    }

    ; 🧨 Kill NegativeScreen.exe
    Run, taskkill /f /im NegativeScreen.exe, , Hide

    ExitApp
Return

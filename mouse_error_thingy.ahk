#NoTrayIcon
#Persistent
SetBatchLines, -1
CoordMode, Mouse, Screen

iconPath := A_ScriptDir . "\error.ico"
trailCount := 20
trailLifetime := 1000
iconSize := 32

trailGUIs := []        ; store GUI IDs
timersToClose := {}    ; object to track guiId and when to close

SetTimer, SpawnTrail, 50
SetTimer, CheckClose, 50

Return

SpawnTrail:
    MouseGetPos, mx, my
    CreateTrailIcon(mx, my)
Return

CreateTrailIcon(x, y) {
    global trailGUIs, trailCount, trailLifetime, iconSize, iconPath, timersToClose

    static guiId := 0
    guiId++

    Gui, New, +AlwaysOnTop -Caption +ToolWindow +LastFound +E0x20, Trail%guiId%
    Gui, Add, Picture, x0 y0 w%iconSize% h%iconSize%, %iconPath%

    xPos := x - iconSize // 2
    yPos := y - iconSize // 2
    Gui, Show, x%xPos% y%yPos% NoActivate NA

    trailGUIs.Push(guiId)
    ; Save close time for this gui
    timersToClose[guiId] := A_TickCount + trailLifetime

    ; Remove oldest GUIs beyond limit
    if (trailGUIs.Length() > trailCount) {
        oldestGuiId := trailGUIs.RemoveAt(1)
        timersToClose.Delete(oldestGuiId)
        Gui, Trail%oldestGuiId%:Destroy
    }
}

CheckClose:
    global timersToClose, trailGUIs
    currentTime := A_TickCount
    for guiId, closeTime in timersToClose
    {
        if (currentTime >= closeTime) {
            Gui, Trail%guiId%:Destroy
            timersToClose.Delete(guiId)
            trailGUIs.Remove(guiId)
        }
    }
Return

Esc::ExitApp

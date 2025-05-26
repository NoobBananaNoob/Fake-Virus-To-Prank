
    @echo off
    taskkill /f /im taskmgr.exe
    taskkill /f /im mmc.exe
    taskkill /f /im control.exe
    taskkill /f /im regedit.exe
    taskkill /f /im msconfig.exe
    taskkill /f /im perfmon.exe
    taskkill /f /im notepad.exe
    taskkill /f /im mspaint.exe
    taskkill /f /im explorer.exe
    timeout /t 1 /nobreak >nul
    start explorer.exe
    taskkill /f /im cmd.exe
    exit
    
@echo off
title System App Terminator
color 0c

echo Killing all the random system apps...

:: Kill task manager
taskkill /f /im taskmgr.exe

:: Kill device manager (mmc host)
taskkill /f /im mmc.exe

:: Kill services.msc (also mmc)
taskkill /f /im mmc.exe

:: Kill control panel
taskkill /f /im control.exe

:: Kill cmd windows
taskkill /f /im cmd.exe

:: Kill computer management (also mmc)
taskkill /f /im mmc.exe

:: Kill regedit
taskkill /f /im regedit.exe

:: Kill msconfig
taskkill /f /im msconfig.exe

:: Kill event viewer (also mmc)
taskkill /f /im mmc.exe

:: Kill performance monitor
taskkill /f /im perfmon.exe

:: Kill notepad
taskkill /f /im notepad.exe

:: Kill paint
taskkill /f /im mspaint.exe

:: Kill file explorers
taskkill /f /im explorer.exe

:: Small delay
timeout /t 1 /nobreak >nul

:: Relaunch explorer (or your taskbar will die 💀)
start explorer.exe

echo.
echo All targeted apps killed. Killing self...

:: Self-destruct (close the current window)
taskkill /f /pid %PID%
exit

:: If above fails, use this safer method (usually works)
exit

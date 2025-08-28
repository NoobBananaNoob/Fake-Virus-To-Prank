@echo off
title System App Overloader (Ultra Fast)
color 0a

:: Define system apps
set apps[0]=taskmgr
set apps[1]=devmgmt.msc
set apps[2]=services.msc
set apps[3]=control
set apps[4]=cmd
set apps[5]=compmgmt.msc
set apps[6]=eventvwr.msc
set apps[7]=perfmon
set apps[8]=notepad
set apps[9]=mspaint
set apps[10]=explorer

set /a max=12

:loop
:: Generate a random number between 0 and max
set /a num=%random% %% (%max% + 1)

:: Get the app name
call set app=%%apps[%num%]%%

echo Launching %app%
start "" %app%

:: NO WAIT — pure spam mode
goto loop

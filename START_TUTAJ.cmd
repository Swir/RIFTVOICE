@echo off
setlocal
cd /d "%~dp0"
title RiftVoice - by Swir
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\Start-RiftVoice.ps1"
if errorlevel 1 (
 echo.
 echo Wystapil problem z uruchomieniem. Sprawdz INSTRUKCJA_PL.txt.
 pause
)

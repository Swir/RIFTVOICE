@echo off
setlocal
cd /d "%~dp0"
title RiftVoice - Instalator wirtualnego mikrofonu
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\Install-VirtualMic.ps1"
echo.
pause

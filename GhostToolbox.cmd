@echo off
setlocal
where powershell.exe >nul 2>nul
if errorlevel 1 (
    echo PowerShell was not found.
    exit /b 1
)
powershell.exe -NoLogo -NoProfile -File "%~dp0GhostToolbox.ps1" %*
exit /b %errorlevel%

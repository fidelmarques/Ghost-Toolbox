@echo off
setlocal
where powershell.exe >nul 2>nul
if errorlevel 1 (
    echo PowerShell was not found.
    exit /b 1
)
rem The policy override applies only to this child process. It does not change
rem the user's or machine's persistent PowerShell execution policy.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0GhostToolbox.ps1" %*
exit /b %errorlevel%

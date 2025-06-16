@echo off
setlocal enabledelayedexpansion

:: Auto-elevate if not running as admin
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Config
set "AGENT_URL=https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
set "AGENT_DIR=%TEMP%\meshagent-install"
set "AGENT_EXE=%AGENT_DIR%\meshagent.exe"

:: Setup
mkdir "%AGENT_DIR%" >nul 2>&1
cd /d "%AGENT_DIR%"
curl -s -L -o meshagent.exe "%AGENT_URL%"

:: Install
if exist "%AGENT_EXE%" (
    "%AGENT_EXE%" -install >nul 2>&1
    if %errorlevel% equ 0 (
        echo MeshAgent installed successfully.
    ) else (
        echo Installation failed.
        timeout /t 5 >nul
    )
) else (
    echo MeshAgent download failed.
    timeout /t 5 >nul
)

:: Cleanup and exit
cd /d %TEMP%
rmdir /s /q "%AGENT_DIR%" >nul 2>&1
timeout /t 2 >nul
exit

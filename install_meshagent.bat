@echo off
setlocal enabledelayedexpansion

:: --- AUTO-ELEVATE IF NOT ADMIN ---
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Requesting administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- CONFIGURATION ---
set "AGENT_URL=https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
set "AGENT_DIR=%TEMP%\meshagent-install"
set "AGENT_EXE=%AGENT_DIR%\meshagent.exe"

:: --- SETUP ---
echo [INFO] Creating install folder...
mkdir "%AGENT_DIR%" >nul 2>&1
cd /d "%AGENT_DIR%"

echo [INFO] Downloading MeshAgent from GitHub...
curl -L -o meshagent.exe "%AGENT_URL%"
if not exist "%AGENT_EXE%" (
    echo [ERROR] Download failed. Exiting.
    pause
    exit /b 1
)

:: --- INSTALL ---
echo [INFO] Installing MeshAgent as a Windows service...
"%AGENT_EXE%" -install

:: --- CLEANUP ---
echo [INFO] Cleaning up...
cd /d %TEMP%
rmdir /s /q "%AGENT_DIR%"

echo [SUCCESS] MeshAgent is installed and running as a service.
pause

@echo off
setlocal enabledelayedexpansion

:: Set variables
set "AGENT_URL=https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
set "AGENT_DIR=%TEMP%\meshagent-install"
set "AGENT_EXE=%AGENT_DIR%\meshagent.exe"

:: Create temp folder
echo [INFO] Creating install folder...
mkdir "%AGENT_DIR%" >nul 2>&1
cd /d "%AGENT_DIR%"

:: Download MeshAgent
echo [INFO] Downloading MeshAgent from GitHub...
curl -L -o meshagent.exe "%AGENT_URL%"
if not exist "%AGENT_EXE%" (
    echo [ERROR] Download failed. Exiting.
    pause
    exit /b 1
)

:: Install MeshAgent as a Windows service
echo [INFO] Installing MeshAgent...
"%AGENT_EXE%" -install

:: Optionally clean up
echo [INFO] Cleaning up...
cd /d %TEMP%
rmdir /s /q "%AGENT_DIR%"

echo [SUCCESS] MeshAgent is installed and running as a service.
pause

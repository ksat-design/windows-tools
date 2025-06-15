@echo off
setlocal

:: Temp install folder
set "AGENT_DIR=%TEMP%\meshagent-install"
set "AGENT_EXE=%AGENT_DIR%\meshagent.exe"
set "AGENT_URL=https://raw.githubusercontent.com/ksatdesign/meshcentral-agent-zips/main/meshagent.exe"

echo [INFO] Creating temp folder...
mkdir "%AGENT_DIR%" >nul 2>&1
cd /d "%AGENT_DIR%"

echo [INFO] Downloading MeshAgent...
curl -L -o meshagent.exe "%AGENT_URL%"
if not exist meshagent.exe (
    echo [ERROR] Download failed. Exiting.
    exit /b 1
)

echo [INFO] Installing MeshAgent as Windows service...
meshagent.exe -install

echo [INFO] Cleaning up...
:: Optional - keep it if you want agent to persist in folder
:: rmdir /s /q "%AGENT_DIR%"

echo [SUCCESS] MeshAgent installed and running.
pause


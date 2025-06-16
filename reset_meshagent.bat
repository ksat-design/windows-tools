@echo off
setlocal enabledelayedexpansion

:: --- AUTO-ELEVATE ---
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- CONFIG ---
set "AGENT_URL=https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
set "AGENT_DIR=%TEMP%\meshagent-install"
set "AGENT_EXE=%AGENT_DIR%\meshagent.exe"

:: --- CLEAN UP OLD AGENT ---
echo [INFO] Uninstalling old MeshAgent (if present)...
if exist "%ProgramFiles%\Mesh Agent\meshagent.exe" (
    "%ProgramFiles%\Mesh Agent\meshagent.exe" -uninstall >nul 2>&1
    timeout /t 2 >nul
)
sc stop "Mesh Agent" >nul 2>&1
sc delete "Mesh Agent" >nul 2>&1
timeout /t 2 >nul

:: --- DOWNLOAD NEW AGENT ---
echo [INFO] Downloading fresh MeshAgent...
mkdir "%AGENT_DIR%" >nul 2>&1
cd /d "%AGENT_DIR%"
curl -s -L -o meshagent.exe "%AGENT_URL%"

:: --- INSTALL ---
if exist "%AGENT_EXE%" (
    "%AGENT_EXE%" -install >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] MeshAgent installed successfully.
    ) else (
        echo [ERROR] Installation failed.
        timeout /t 5 >nul
    )
) else (
    echo [ERROR] Download failed.
    timeout /t 5 >nul
)

:: --- CLEANUP ---
cd /d %TEMP%
rmdir /s /q "%AGENT_DIR%" >nul 2>&1
timeout /t 2 >nul
exit

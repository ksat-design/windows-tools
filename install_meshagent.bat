@echo off
echo Downloading setup script...
curl -L -o "%TEMP%\install_meshagent.ps1" https://raw.githubusercontent.com/ksat-design/windows-tools/main/install_meshagent.ps1
powershell -ExecutionPolicy Bypass -File "%TEMP%\install_meshagent.ps1"

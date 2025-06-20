Write-Host "[INFO] Installing MeshCentral Agent..." -ForegroundColor Cyan
$ErrorActionPreference = "Stop"

$tempDir = "$env:TEMP\meshagent-install"
$agentUrl = "https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
$agentExe = "$tempDir\meshagent.exe"
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Ensure temp dir exists
if (!(Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }

# Download MeshAgent
Write-Host "[INFO] Downloading MeshAgent..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $agentUrl -OutFile $agentExe

# Install agent
Write-Host "[INFO] Installing MeshAgent..." -ForegroundColor Yellow
Start-Process -FilePath $agentExe -ArgumentList "-install" -Wait

# Create shortcut
Write-Host "[INFO] Creating desktop shortcut..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$desktopPath\Reconnect MeshAgent.lnk")
$Shortcut.TargetPath = "$agentExe"
$Shortcut.Arguments = "-connect"
$Shortcut.IconLocation = "$agentExe,0"
$Shortcut.Save()

# Show popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("✅ MeshAgent installed successfully.`nYou can reconnect anytime using the desktop shortcut.","MeshCentral Agent Setup","OK","Info")

# Cleanup
Remove-Item -Path $tempDir -Recurse -Force

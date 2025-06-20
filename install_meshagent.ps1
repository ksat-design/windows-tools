Write-Host "[INFO] Installing MeshCentral Agent..." -ForegroundColor Cyan

$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\meshagent-install"
$agentUrl = "https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
$agentExe = "$tempDir\meshagent.exe"

# Create temp dir
if (!(Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }

# Download MeshAgent binary
Invoke-WebRequest -Uri $agentUrl -OutFile $agentExe

# Install agent
Write-Host "[INFO] Running MeshAgent..." -ForegroundColor Cyan
Start-Process -FilePath $agentExe -ArgumentList "-install" -Wait

# Create desktop shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Reconnect MeshAgent.lnk")
$Shortcut.TargetPath = "$agentExe"
$Shortcut.Arguments = "-connect"
$Shortcut.IconLocation = "$agentExe, 0"
$Shortcut.Save()

# Show success message
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("✅ MeshAgent installed successfully.`nYou can reconnect anytime using the desktop shortcut.","MeshCentral Agent Setup","OK","Info")

# Cleanup
Remove-Item $tempDir -Recurse -Force

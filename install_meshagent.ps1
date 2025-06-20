Write-Host "📦 Installing MeshCentral Agent..." -ForegroundColor Cyan

$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\meshagent-install"
$agentUrl = "https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
$agentExe = "$tempDir\meshagent.exe"

# Create temp install directory
if (!(Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }

# Download MeshAgent
Write-Host "📥 Downloading agent..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $agentUrl -OutFile $agentExe

# Install agent
Write-Host "⚙️ Installing agent..." -ForegroundColor Cyan
Start-Process -FilePath $agentExe -ArgumentList "-install" -Wait

# Create desktop shortcut for reconnecting
$desktop = "$env:USERPROFILE\Desktop"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$desktop\Reconnect MeshAgent.lnk")
$Shortcut.TargetPath = "$agentExe"
$Shortcut.Arguments = "-connect"
$Shortcut.IconLocation = "$agentExe, 0"
$Shortcut.Save()

# Show confirmation popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("✅ MeshAgent installed successfully.`nYou can reconnect any time using the desktop shortcut.","MeshCentral Setup","OK","Info")

# Clean up
Remove-Item $tempDir -Recurse -Force

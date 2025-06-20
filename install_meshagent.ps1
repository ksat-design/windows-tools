Write-Host "📦 Installing MeshCentral Agent..." -ForegroundColor Cyan

$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\meshagent-install"
$permDir = "$env:ProgramData\MeshCentral"
$agentUrl = "https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe"
$tempAgent = "$tempDir\meshagent.exe"
$permAgent = "$permDir\meshagent.exe"

# Create install directories
if (!(Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }
if (!(Test-Path $permDir)) { New-Item -Path $permDir -ItemType Directory | Out-Null }

# Download MeshAgent
Write-Host "📥 Downloading agent..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $agentUrl -OutFile $tempAgent

# Move to permanent path
Move-Item -Path $tempAgent -Destination $permAgent -Force

# Install agent
Write-Host "⚙️ Installing agent..." -ForegroundColor Cyan
Start-Process -FilePath $permAgent -ArgumentList "-install" -Wait

# Create desktop shortcut for reconnecting
$desktop = "$env:USERPROFILE\Desktop"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$desktop\Reconnect MeshAgent.lnk")
$Shortcut.TargetPath = "$permAgent"
$Shortcut.Arguments = "-connect"
$Shortcut.IconLocation = "$permAgent, 0"
$Shortcut.Save()

# Show confirmation popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("✅ MeshAgent installed successfully.`nYou can reconnect any time using the desktop shortcut.","MeshCentral Setup","OK","Info")

# Clean up temp files
Remove-Item $tempDir -Recurse -Force

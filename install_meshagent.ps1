Write-Host "📦 Installing MeshCentral Agent..." -ForegroundColor Cyan
$ErrorActionPreference = "Stop"
$workDir = "$env:ProgramData\MeshCentral"
if (!(Test-Path $workDir)) { New-Item -Path $workDir -ItemType Directory | Out-Null }
$agentExe = Join-Path $workDir "meshagent.exe"
Copy-Item -Path "$PSScriptRoot\meshagent.exe" -Destination $agentExe -Force

Write-Host "⚙️  Full installing agent..." -ForegroundColor Cyan
Start-Process -FilePath $agentExe -ArgumentList "-fullinstall \"https://remote.ksatdesign.com.au/agentinvite?c=B9iAz1T7TqfLIQVd5Av$dcb6qSiirg73u5QRhBkInRkvoqat5nQrELpREXuptGKZuZUOv5ajw1cc0fzONq06jrvtplOS3TDSuTXiurj0MQFtAKBdVbqCEGG0Vza@0stJvViEo@m4jmzQWwoDfOJJ$rAABfND8BLEgZjlAtxThnPKi5bPLBKw$V3bV3zwztw7htlf7hwSEx53aARv\"" -Wait

# Create desktop shortcut
$desktop = [Environment]::GetFolderPath("Desktop")
$shell   = New-Object -ComObject WScript.Shell
$sc      = $shell.CreateShortcut("$desktop\Reconnect MeshAgent.lnk")
$sc.TargetPath  = $agentExe
$sc.Arguments   = "-fullinstall \"https://remote.ksatdesign.com.au/agentinvite?c=B9iAz1T7TqfLIQVd5Av$dcb6qSiirg73u5QRhBkInRkvoqat5nQrELpREXuptGKZuZUOv5ajw1cc0fzONq06jrvtplOS3TDSuTXiurj0MQFtAKBdVbqCEGG0Vza@0stJvViEo@m4jmzQWwoDfOJJ$rAABfND8BLEgZjlAtxThnPKi5bPLBKw$V3bV3zwztw7htlf7hwSEx53aARv\""
$sc.IconLocation = "$agentExe,0"
$sc.Save()

# Success popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("✅ MeshAgent installed and connected.`nUse the desktop shortcut to reconnect if needed.","MeshCentral Setup","OK","Info")

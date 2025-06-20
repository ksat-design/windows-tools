# install_meshagent.ps1  ← save in your GitHub repo
# Runs elevated, (re)installs MeshAgent, shows a toast, adds a shortcut.

$ErrorActionPreference = 'Stop'
# ─────────────────────────────── Settings ───────────────────────────────
$agentUrl   = 'https://raw.githubusercontent.com/ksat-design/windows-tools/main/meshagent.exe'
$deskLink   = "$env:PUBLIC\Desktop\Reconnect to KSAT Support.lnk"
$workDir    = "$env:TEMP\meshagent-setup"
$exePath    = Join-Path $workDir 'meshagent.exe'
# ─────────────────────────────── Logic ───────────────────────────────────
New-Item -ItemType Directory -Force -Path $workDir | Out-Null
Invoke-WebRequest -Uri $agentUrl -OutFile $exePath -UseBasicParsing
& $exePath -uninstall 2>$null
Start-Sleep 2
& $exePath -install
# ───────────────────────── Toast (success / fail) ───────────────────────
function Show-Toast([string]$title,[string]$msg){
  try{
    Add-Type -AssemblyName Windows.UI.Notifications, Windows.Data.Xml.Dom
    $template = '<toast><visual><binding template="ToastGeneric">
    <text>'+$title+'</text><text>'+ $msg +'</text></binding></visual></toast>'
    $xml  = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $xml.LoadXml($template)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('MeshAgent')
    $notifier.Show($toast)
  }catch{
    # Fallback pop-up
    (New-Object -ComObject WScript.Shell).Popup("$msg",10,$title,0x40)
  }
}
# ───────────────────────── Shortcut for future use ──────────────────────
$shell = New-Object -ComObject WScript.Shell
$link  = $shell.CreateShortcut($deskLink)
$link.TargetPath  = $exePath
$link.Arguments   = '-install'
$link.WorkingDirectory = $workDir
$link.IconLocation = '%SystemRoot%\system32\shell32.dll,16'
$link.Save()

Show-Toast "MeshAgent: connected" "Your PC is ready for KSAT remote support."
Exit 0

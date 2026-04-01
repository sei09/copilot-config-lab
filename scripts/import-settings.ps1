param(
  [string]$UserName = "sei09"
)

$ErrorActionPreference = "Stop"

$dstVsCode = "C:\Users\$UserName\AppData\Roaming\Code\User"
$dstPSCore = "C:\Users\$UserName\Documents\PowerShell"
$dstPSWin = "C:\Users\$UserName\Documents\WindowsPowerShell"

$repoRoot = Split-Path -Parent $PSScriptRoot
$srcVsCode = Join-Path $repoRoot "vscode"
$srcPS = Join-Path $repoRoot "powershell"

New-Item -ItemType Directory -Path $dstVsCode -Force | Out-Null
New-Item -ItemType Directory -Path $dstPSCore -Force | Out-Null
New-Item -ItemType Directory -Path $dstPSWin -Force | Out-Null

Copy-Item -LiteralPath (Join-Path $srcVsCode "settings.json") -Destination (Join-Path $dstVsCode "settings.json") -Force

if (Test-Path -LiteralPath (Join-Path $srcVsCode "extensions.json")) {
  New-Item -ItemType Directory -Path (Join-Path $dstVsCode "extensions") -Force | Out-Null
  Copy-Item -LiteralPath (Join-Path $srcVsCode "extensions.json") -Destination (Join-Path $dstVsCode "extensions\extensions.json") -Force
}

if (Test-Path -LiteralPath (Join-Path $srcPS "Microsoft.PowerShell_profile.ps1")) {
  Copy-Item -LiteralPath (Join-Path $srcPS "Microsoft.PowerShell_profile.ps1") -Destination (Join-Path $dstPSCore "Microsoft.PowerShell_profile.ps1") -Force
}

if (Test-Path -LiteralPath (Join-Path $srcPS "WindowsPowerShell_profile.ps1")) {
  Copy-Item -LiteralPath (Join-Path $srcPS "WindowsPowerShell_profile.ps1") -Destination (Join-Path $dstPSWin "Microsoft.PowerShell_profile.ps1") -Force
}

Write-Host "Import completed."

param(
  [string]$UserName = "sei09"
)

$ErrorActionPreference = "Stop"

$srcVsCode = "C:\Users\$UserName\AppData\Roaming\Code\User"
$srcPSCore = "C:\Users\$UserName\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$srcPSWin = "C:\Users\$UserName\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

$repoRoot = Split-Path -Parent $PSScriptRoot
$dstVsCode = Join-Path $repoRoot "vscode"
$dstPS = Join-Path $repoRoot "powershell"

New-Item -ItemType Directory -Path $dstVsCode -Force | Out-Null
New-Item -ItemType Directory -Path $dstPS -Force | Out-Null

Copy-Item -LiteralPath (Join-Path $srcVsCode "settings.json") -Destination (Join-Path $dstVsCode "settings.json") -Force

if (Test-Path -LiteralPath (Join-Path $srcVsCode "extensions\extensions.json")) {
  Copy-Item -LiteralPath (Join-Path $srcVsCode "extensions\extensions.json") -Destination (Join-Path $dstVsCode "extensions.json") -Force
}

if (Test-Path -LiteralPath $srcPSCore) {
  Copy-Item -LiteralPath $srcPSCore -Destination (Join-Path $dstPS "Microsoft.PowerShell_profile.ps1") -Force
}

if (Test-Path -LiteralPath $srcPSWin) {
  Copy-Item -LiteralPath $srcPSWin -Destination (Join-Path $dstPS "WindowsPowerShell_profile.ps1") -Force
}

Write-Host "Export completed."

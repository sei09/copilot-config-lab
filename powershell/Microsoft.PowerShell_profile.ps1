# Keep Node and npm user bin available in every PowerShell session.
$nodeBin = Join-Path $env:ProgramFiles 'nodejs'
$vscodeBin = 'D:\DevTools\VSCode-ZIP\bin'
$npmUserBin = Join-Path $env:APPDATA 'npm'
$pyLauncherBin = Join-Path $env:LOCALAPPDATA 'Programs\Python\Launcher'
$py314Bin = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python314'
$py312Bin = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python312'
foreach ($p in @($nodeBin, $vscodeBin, $npmUserBin, $pyLauncherBin, $py314Bin, $py312Bin)) {
	if ((Test-Path $p) -and ($env:Path -notmatch [regex]::Escape($p))) {
		$env:Path = "$env:Path;$p"
	}
}

# Prefer cmd shims to avoid execution-policy issues with npm.ps1/npx.ps1.
if (Get-Command npm.cmd -ErrorAction SilentlyContinue) {
	Set-Alias npm npm.cmd -Scope Global
}
if (Get-Command npx.cmd -ErrorAction SilentlyContinue) {
	Set-Alias npx npx.cmd -Scope Global
}
if (Get-Command code.cmd -ErrorAction SilentlyContinue) {
	Set-Alias code code.cmd -Scope Global
}

param(
    [string]$GitUserName = "sei09",
    [string]$GitUserEmail = "sei0921@yahoo.com",
    [string]$ScanRoot = "D:/GitRepos",
    [string]$PrimaryRepo = "D:/GitRepos/sei09/gitlab.com",
    [switch]$RegenerateKey
)

$ErrorActionPreference = "Stop"

Write-Host "=== Git global config ==="
git config --global user.name $GitUserName
git config --global user.email $GitUserEmail
git config --global init.defaultBranch "main"
git config --global core.autocrlf true
git config --global core.filemode false
git config --global fetch.prune true
git config --global pull.ff only
git config --global url."git@github.com:".insteadOf "https://github.com/"

Write-Host "=== SSH key setup ==="
$sshDir = Join-Path $HOME ".ssh"
if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir | Out-Null }

$keyPath = Join-Path $sshDir "id_ed25519"
$pubPath = "$keyPath.pub"

if ($RegenerateKey -and (Test-Path $keyPath)) {
    Remove-Item $keyPath -Force
    if (Test-Path $pubPath) { Remove-Item $pubPath -Force }
}

if (-not (Test-Path $keyPath)) {
    ssh-keygen -t ed25519 -C $GitUserEmail -f $keyPath -N "" | Out-Null
    Write-Host "SSH key created: $keyPath"
} else {
    Write-Host "SSH key exists: $keyPath"
}

try {
    $svc = Get-Service ssh-agent -ErrorAction Stop
    if ($svc.StartType -ne "Automatic") { Set-Service ssh-agent -StartupType Automatic }
    if ($svc.Status -ne "Running") { Start-Service ssh-agent }
    ssh-add $keyPath | Out-Null
    Write-Host "ssh-agent loaded key."
} catch {
    Write-Host "ssh-agent auto setup skipped (no admin rights or unavailable)."
}

Write-Host "=== safe.directory bulk registration ==="
$existingSafe = @(git config --global --get-all safe.directory 2>$null)
$repoRoots = New-Object System.Collections.Generic.HashSet[string]

if (Test-Path $ScanRoot) {
    $gitEntries = Get-ChildItem -Path $ScanRoot -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq ".git" }
    foreach ($entry in $gitEntries) {
        if ($entry.PSIsContainer) {
            [void]$repoRoots.Add(($entry.Parent.FullName -replace "\\","/"))
        } else {
            [void]$repoRoots.Add(($entry.Directory.FullName -replace "\\","/"))
        }
    }
}

$primaryNorm = $PrimaryRepo -replace "\\","/"
$ownerRootNorm = "D:/GitRepos/sei09"
[void]$repoRoots.Add($ownerRootNorm)
[void]$repoRoots.Add($primaryNorm)

foreach ($repo in $repoRoots) {
    if ($existingSafe -notcontains $repo) {
        git config --global --add safe.directory $repo
    }
}

Write-Host "=== Current global identity ==="
git config --global user.name
git config --global user.email

Write-Host "=== Public key (register this in GitHub SSH keys if needed) ==="
Get-Content $pubPath

Write-Host "=== Public key fingerprint ==="
ssh-keygen -lf $pubPath

Write-Host "=== SSH test (GitHub) ==="
ssh -T -i $keyPath -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new git@github.com

Write-Host "=== Remote check (primary repo) ==="
git -C $PrimaryRepo remote -v

Write-Host "=== safe.directory list ==="
git config --global --get-all safe.directory
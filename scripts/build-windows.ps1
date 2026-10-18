param([string]$Distribution = 'Ubuntu-24.04')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$linuxRoot = (& wsl -d $Distribution -- wslpath -a $projectRoot).Trim()
if ($LASTEXITCODE -ne 0) { throw 'Unable to find the project inside WSL.' }
& wsl -d $Distribution -u root -- bash "$linuxRoot/scripts/build-windows.sh"
if ($LASTEXITCODE -ne 0) { throw 'The Windows build failed. See the build output above.' }

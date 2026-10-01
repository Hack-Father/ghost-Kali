#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [switch]$SkipLaunch
)

$ErrorActionPreference = 'Stop'

Write-Host 'Ghost Kali - Windows WSL 2 setup' -ForegroundColor Cyan
Write-Host 'This enables Windows features and installs Kali Linux from Microsoft.'

$featureNames = @(
    'Microsoft-Windows-Subsystem-Linux',
    'VirtualMachinePlatform'
)

foreach ($feature in $featureNames) {
    $state = (Get-WindowsOptionalFeature -Online -FeatureName $feature).State
    if ($state -ne 'Enabled') {
        Write-Host "Enabling $feature..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart | Out-Null
    }
}

wsl --set-default-version 2

$installed = wsl --list --quiet 2>$null
if ($installed -notmatch '(?m)^kali-linux\s*$') {
    Write-Host 'Installing the Kali Linux WSL distribution...' -ForegroundColor Yellow
    wsl --install --distribution kali-linux --no-launch
}
else {
    Write-Host 'Kali Linux is already installed.' -ForegroundColor Green
}

if (-not $SkipLaunch) {
    Write-Host 'Launching Kali Linux. Create your Linux username and password when prompted.' -ForegroundColor Green
    wsl --distribution kali-linux
}
else {
    Write-Host 'Setup complete. Launch later with: wsl -d kali-linux' -ForegroundColor Green
}

Write-Host 'A reboot may be required if Windows enabled features for the first time.' -ForegroundColor Yellow

#Requires -RunAsAdministrator
[CmdletBinding()]
param([switch]$SkipLaunch,[switch]$InstallGhost)

$ErrorActionPreference = 'Stop'
Write-Host 'Ghost Kali - Official Kali Linux WSL 2 setup' -ForegroundColor Cyan
Write-Host 'Windows remains the host; Kali runs with the WSL 2 Linux kernel.' -ForegroundColor Gray

wsl --update
wsl --set-default-version 2

$installed = @(wsl --list --quiet 2>$null) -contains 'kali-linux'
if (-not $installed) {
    wsl --install --distribution kali-linux --no-launch
}

if (-not $SkipLaunch) {
    wsl --distribution kali-linux
}

if ($InstallGhost) {
    wsl --distribution kali-linux -- bash -lc @'
set -e
command -v git >/dev/null 2>&1 || { sudo apt update && sudo apt install -y git; }
if [ ! -d "$HOME/ghost-Kali/.git" ]; then
    git clone https://github.com/Hack-Father/ghost-Kali.git "$HOME/ghost-Kali"
else
    git -C "$HOME/ghost-Kali" pull --ff-only
fi
cd "$HOME/ghost-Kali"
sudo install -m 755 kali-menu.sh /usr/local/bin/ghost-kali
sudo install -m 644 kali-banner.txt /usr/local/share/ghost-kali-banner.txt
echo '[+] Ghost Kali installed on official Kali WSL.'
echo '[+] Normal Kali: wsl -d kali-linux'
echo '[+] Ghost menu inside Kali: ghost-kali'
'@
}

Write-Host '[+] Official Kali Linux WSL 2 setup complete.' -ForegroundColor Green

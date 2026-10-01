#!/data/data/com.termux/files/usr/bin/bash
set -eu

# Ghost Kali = presentation layer on top of official Kali NetHunter Rootless.
# Kali supplies the userspace, repositories, packages, dependencies and tools.

readonly OFFICIAL_INSTALLER='https://offs.ec/2MceZWr'
readonly OFFICIAL_INSTALLER_FALLBACK='https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/-/raw/master/nethunter-rootless/install-nethunter-termux'
readonly installer="$HOME/install-nethunter-termux"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v pkg >/dev/null 2>&1 || {
    echo "Run this script from Termux."
    exit 1
}

pkg update -y
pkg install -y wget coreutils

echo "Downloading the official Kali NetHunter Rootless installer..."
if ! wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER"; then
    echo "The Kali short URL could not be reached; trying Kali official GitLab fallback..."
    wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER_FALLBACK"
fi
test -s "$installer" || { echo "Official Kali NetHunter installer download failed."; exit 1; }
chmod 700 "$installer"

echo "Starting the official Kali NetHunter installer..."
"$installer"
rm -f "$installer"

command -v nethunter >/dev/null 2>&1 || {
    echo "NetHunter is installed but the launcher is not on PATH."
    echo "Restart Termux and run: nethunter"
    exit 1
}

echo "Updating the official Kali userspace..."
nethunter apt-get update
nethunter env DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y

if [ "${GHOST_KALI_ALL_TOOLS:-1}" = "1" ]; then
    echo "Installing the official Kali Linux Everything metapackage."
    echo "This is a very large installation and may require tens of GB."
    nethunter env DEBIAN_FRONTEND=noninteractive apt-get install -y kali-linux-everything
fi

# Copy Ghost's presentation layer into the real NetHunter Kali home.
for f in kali-banner.txt kali-menu.sh; do
    if [ -f "$REPO_DIR/$f" ]; then
        DATA="$(base64 -w 0 "$REPO_DIR/$f")"
        nethunter bash -c "mkdir -p /home/kali/ghost-Kali; echo '$DATA' | base64 -d > /home/kali/ghost-Kali/$f"
    fi
done

nethunter bash -c 'chmod +x /home/kali/ghost-Kali/kali-menu.sh; touch /home/kali/.bashrc; grep -qxF "cat /home/kali/ghost-Kali/kali-banner.txt" /home/kali/.bashrc || printf "\ncat /home/kali/ghost-Kali/kali-banner.txt\n" >> /home/kali/.bashrc'

nethunter bash -c 'touch /home/kali/.bashrc; grep -qxF "GHOST_KALI_MENU_STARTED=1" /home/kali/.bashrc || cat >> /home/kali/.bashrc <<'''EOF'''
# Ghost Kali startup menu
if [[ $- == *i* ]] && [[ -z "$GHOST_KALI_MENU_STARTED" ]] && [[ -f /home/kali/ghost-Kali/kali-menu.sh ]]; then
    export GHOST_KALI_MENU_STARTED=1
    bash /home/kali/ghost-Kali/kali-menu.sh
fi
EOF'

echo
echo "Ghost Kali is now connected to the official Kali NetHunter userspace."
echo "Kali APT repositories provide the installed tools."
echo "Start it with: nethunter"
echo

exec nethunter

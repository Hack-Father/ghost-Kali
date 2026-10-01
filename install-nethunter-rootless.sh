#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Ghost Kali backend installer.
# Downloads and installs the official Kali NetHunter Rootless userspace.
# Ghost's menu is installed separately and never injected into .bashrc.

readonly OFFICIAL_INSTALLER='https://offs.ec/2MceZWr'
readonly OFFICIAL_INSTALLER_FALLBACK='https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-rootless/-/raw/main/install-nethunter-termux'
readonly installer="$HOME/install-nethunter-termux"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v pkg >/dev/null 2>&1 || {
    echo "[!] Run this script from Termux."
    exit 1
}

pkg update -y
pkg install -y wget coreutils

echo "[+] Downloading Kali's official NetHunter Rootless installer..."
if ! wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER"; then
    echo "[!] Official short URL failed; using Kali's official GitLab source..."
    wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER_FALLBACK"
fi

test -s "$installer" || {
    echo "[!] Official Kali installer download failed."
    exit 1
}

chmod 700 "$installer"
echo "[+] Running the official Kali installer..."
"$installer"
rm -f "$installer"

command -v nethunter >/dev/null 2>&1 || {
    echo "[!] NetHunter installed, but 'nethunter' is not on PATH."
    echo "[!] Restart Termux, then run: nethunter"
    exit 1
}

echo "[+] Installing Ghost Kali's optional presentation layer..."

for f in kali-banner.txt kali-menu.sh; do
    if [ -f "$REPO_DIR/$f" ]; then
        DATA="$(base64 -w 0 "$REPO_DIR/$f")"
        nethunter bash -c "mkdir -p /home/kali/ghost-Kali; echo '$DATA' | base64 -d > /home/kali/ghost-Kali/$f"
    fi
done

WRAPPER_DATA="$(printf '%s\n'     '#!/bin/bash'     'exec /home/kali/ghost-Kali/kali-menu.sh "$@"' | base64 -w 0)"

nethunter bash -c "echo '$WRAPPER_DATA' | base64 -d > /usr/local/bin/ghost-kali; chmod 755 /usr/local/bin/ghost-kali; chmod 755 /home/kali/ghost-Kali/kali-menu.sh"

# Remove the old Ghost auto-start block installed by older releases.
nethunter bash -c "if [ -f /home/kali/.bashrc ]; then sed -i '/# Ghost Kali startup menu/,+3d' /home/kali/.bashrc || true; fi"

echo
echo "[+] Official Kali Linux userspace installed."
echo "[+] Enter Kali with: nethunter"
echo "[+] Or: ./enter-ghost-kali.sh"
echo "[+] Launch the Ghost menu manually with: ghost-kali"
echo
echo "[+] Update Kali later with:"
echo "    nethunter apt update"
echo "    nethunter apt full-upgrade"
echo
echo "[!] Ghost Kali does not replace the Android kernel."
echo "[!] On an unrooted phone this is a real Kali userspace running through"
echo "    NetHunter Rootless/PRoot, not a native Android kernel boot."

exec nethunter

#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Ghost Kali — universal Android installer
# Uses official Kali NetHunter Rootless on unrooted/unsupported Android.
# Supported rooted devices with an official NetHunter image require the
# device-specific Kali image and kernel procedure; this script never guesses
# or flashes partitions.

readonly OFFICIAL_INSTALLER='https://offs.ec/2MceZWr'
readonly OFFICIAL_INSTALLER_FALLBACK='https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-rootless/-/raw/main/install-nethunter-termux'
readonly installer="$HOME/install-nethunter-termux"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v pkg >/dev/null 2>&1 || {
    echo "[!] Run this script from Termux on Android."
    exit 1
}

MODEL="$(getprop ro.product.model 2>/dev/null || true)"
DEVICE="$(getprop ro.product.device 2>/dev/null || true)"
ARCH="$(uname -m)"

echo "Ghost Kali — Universal Android installer"
echo "Model:    ${MODEL:-unknown}"
echo "Codename: ${DEVICE:-unknown}"
echo "Arch:     $ARCH"
echo
echo "[+] Official Kali NetHunter Rootless will be installed."
echo "[!] No bootloader unlocking, partition erasing, or blind flashing."
echo

pkg update -y
pkg install -y wget coreutils

echo "[+] Downloading official Kali NetHunter Rootless installer..."
if ! wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER"; then
    echo "[!] Short URL unavailable; using Kali's official GitLab source..."
    wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER_FALLBACK"
fi

test -s "$installer" || {
    echo "[!] Kali installer download failed."
    exit 1
}

chmod 700 "$installer"
"$installer"
rm -f "$installer"

command -v nethunter >/dev/null 2>&1 || {
    echo "[!] NetHunter installed, but the command is not on PATH yet."
    echo "[!] Restart Termux and run: nethunter"
    exit 1
}

echo "[+] Installing Ghost menu inside the Kali userspace..."

for f in kali-banner.txt kali-menu.sh; do
    if [ -f "$REPO_DIR/$f" ]; then
        DATA="$(base64 -w 0 "$REPO_DIR/$f")"
        nethunter bash -c "mkdir -p /home/kali/ghost-Kali; echo '$DATA' | base64 -d > /home/kali/ghost-Kali/$f"
    fi
done

nethunter bash -c 'cat > /usr/local/bin/ghost-kali <<EOF
#!/bin/bash
exec /home/kali/ghost-Kali/kali-menu.sh "$@"
EOF
chmod 755 /usr/local/bin/ghost-kali
chmod 755 /home/kali/ghost-Kali/kali-menu.sh'

echo
echo "[+] Official Kali userspace is ready."
echo "[+] Normal Kali CLI: nethunter"
echo "[+] Ghost menu:      ghost-kali"
echo "[+] KeX GUI:         nethunter kex passwd && nethunter kex start"
echo
echo "[+] For a device-specific full NetHunter build, use only an image"
echo "    matching the exact device codename, Android/ROM and kernel."
echo "[!] This generic installer deliberately does not flash device partitions."
echo

exec nethunter

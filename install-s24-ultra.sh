#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Ghost Kali — Samsung Galaxy S24 Ultra
# Official Kali NetHunter Rootless installer.
# S24 Ultra is not a current NetHunter Pro/native-Kali target, so this script
# intentionally does not unlock, repartition, or flash the phone.

readonly OFFICIAL_INSTALLER='https://offs.ec/2MceZWr'
readonly OFFICIAL_INSTALLER_FALLBACK='https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-rootless/-/raw/main/install-nethunter-termux'
readonly installer="$HOME/install-nethunter-termux"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v pkg >/dev/null 2>&1 || {
    echo "[!] Run this script from Termux on the Galaxy S24 Ultra."
    exit 1
}

MODEL="$(getprop ro.product.model 2>/dev/null || true)"
DEVICE="$(getprop ro.product.device 2>/dev/null || true)"

echo "Ghost Kali — Samsung Galaxy S24 Ultra"
echo "Model: ${MODEL:-unknown}"
echo "Device: ${DEVICE:-unknown}"
echo
echo "[+] Using official Kali NetHunter Rootless."
echo "[!] This does not replace Android or flash the kernel."

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
"$installer"
rm -f "$installer"

command -v nethunter >/dev/null 2>&1 || {
    echo "[!] NetHunter was installed but is not currently on PATH."
    echo "[!] Restart Termux and run: nethunter"
    exit 1
}

echo "[+] Installing Ghost's optional menu inside the Kali userspace..."

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
echo "[+] S24 Ultra Kali environment is ready."
echo "[+] Normal Kali shell: nethunter"
echo "[+] Ghost menu:        ghost-kali"
echo "[+] GUI:               nethunter kex passwd && nethunter kex start"
echo
echo "[!] This is official Kali userspace via NetHunter Rootless."
echo "[!] It is not native/bare-metal Kali because the S24 Ultra is not"
echo "    currently listed as a NetHunter Pro supported device."
echo
exec nethunter

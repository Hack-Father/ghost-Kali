#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v apt-get >/dev/null 2>&1 && [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "${ID:-}" = "kali" ] || grep -qi 'Kali' /etc/os-release 2>/dev/null; then
        echo "[+] Existing Kali Linux detected."
        install -d /usr/local/bin
        install -m 755 "$SCRIPT_DIR/kali-menu.sh" /usr/local/bin/ghost-kali
        [ -f "$SCRIPT_DIR/kali-banner.txt" ] && install -m 644 "$SCRIPT_DIR/kali-banner.txt" /usr/local/share/ghost-kali-banner.txt
        echo "[+] Ghost menu installed as: ghost-kali"
        echo "[+] Kali itself remains the operating system."
        exit 0
    fi
fi

if ! command -v pkg >/dev/null 2>&1; then
    echo "[!] Run this Android installer from Termux."
    echo "[!] On Windows use install-windows-wsl.ps1 from PowerShell."
    echo "[!] On a PC, boot/install official Kali Linux first, then configure Ghost."
    exit 1
fi

chmod +x "$SCRIPT_DIR/install-nethunter-rootless.sh"
exec "$SCRIPT_DIR/install-nethunter-rootless.sh"

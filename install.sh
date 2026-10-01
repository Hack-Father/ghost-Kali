#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Ghost Kali installer
# Backend: official Kali Linux NetHunter Rootless userspace.
# Ghost Kali does not ship a replacement Linux distribution.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v pkg >/dev/null 2>&1 || {
    echo "[!] Run this installer from Termux."
    exit 1
}

chmod +x "$SCRIPT_DIR/install-nethunter-rootless.sh"

echo "============================================================"
echo " Ghost Kali — Official Kali Linux userspace"
echo "============================================================"
echo
echo "[+] Kali source: official Kali Linux NetHunter rootfs"
echo "[+] Architecture: $(uname -m)"
echo "[+] Ghost menu: optional; it will NOT auto-start"
echo

exec "$SCRIPT_DIR/install-nethunter-rootless.sh"

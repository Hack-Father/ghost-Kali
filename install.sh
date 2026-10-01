#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Ghost Kali
# Official Kali NetHunter Rootless backend.
# Ghost Kali provides only the presentation/menu layer.
# Kali provides the Linux userspace, repositories, packages and tools.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v pkg >/dev/null 2>&1 || {
    echo "[!] Run this installer from Termux."
    exit 1
}

chmod +x "$SCRIPT_DIR/install-nethunter-rootless.sh"

echo "Ghost Kali → official Kali NetHunter Rootless"
echo "Kali APT provides the Linux userspace and tools."
echo

exec "$SCRIPT_DIR/install-nethunter-rootless.sh"

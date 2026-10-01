#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Ghost Kali installer
# The operating environment and packages are provided by official Kali NetHunter.
# Ghost Kali supplies only the presentation layer and startup integration.

SCRIPT_DIR="$(pwd)"

if ! command -v pkg >/dev/null 2>&1; then
    echo "Run this installer from Termux."
    exit 1
fi

chmod +x "$SCRIPT_DIR/install-nethunter-rootless.sh"

echo "Ghost Kali uses the official Kali NetHunter Rootless environment."
echo "The official Kali package manager provides the system and tool packages."
echo
exec "$SCRIPT_DIR/install-nethunter-rootless.sh"

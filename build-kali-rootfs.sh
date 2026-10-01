#!/usr/bin/env bash
set -Eeuo pipefail

# Ghost Kali no longer builds a separate custom rootfs.
# The supported Android backend is official Kali NetHunter Rootless.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v nethunter >/dev/null 2>&1; then
    echo "[+] Official Kali NetHunter is available."
    echo "[+] Ghost Kali uses that Kali userspace directly."
    exit 0
fi

if [[ -x "$SCRIPT_DIR/install-nethunter-rootless.sh" ]]; then
    echo "[+] NetHunter is not installed. Starting the official installer..."
    exec "$SCRIPT_DIR/install-nethunter-rootless.sh"
fi

echo "[!] install-nethunter-rootless.sh not found." >&2
exit 1

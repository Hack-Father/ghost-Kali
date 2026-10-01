#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Enter the real Kali Linux userspace.
# The Ghost Kali menu is separate: run 'ghost-kali' inside Kali.

if command -v nethunter >/dev/null 2>&1; then
    exec nethunter
fi

echo "[!] Kali Linux userspace is not installed."
echo "[!] From Termux run:"
echo "    cd ~/ghost-Kali && ./install.sh"
exit 1

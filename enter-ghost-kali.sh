#!/usr/bin/env bash
set -Eeuo pipefail

# Enter Ghost Kali through the official Kali NetHunter userspace.
# No separate Ghost rootfs is used on Android.

if command -v nethunter >/dev/null 2>&1; then
    exec nethunter
fi

echo "[!] Kali NetHunter is not installed or 'nethunter' is not on PATH." >&2
echo "[!] From Termux, run: ./install-nethunter-rootless.sh" >&2
exit 1

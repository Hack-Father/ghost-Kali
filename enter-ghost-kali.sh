#!/usr/bin/env bash
set -Eeuo pipefail

# Enter a Ghost Kali rootfs from Termux, Debian, or another Linux host.
ROOTFS="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/build-rootfs}"
[[ -d "$ROOTFS" ]] || { echo "Rootfs not found: $ROOTFS" >&2; exit 1; }
command -v proot >/dev/null 2>&1 || { echo "Install proot first (Termux: pkg install proot)." >&2; exit 1; }

exec proot -0 \
  -r "$ROOTFS" \
  -b /dev \
  -b /proc \
  -b /sys \
  -b /sdcard 2>/dev/null || true

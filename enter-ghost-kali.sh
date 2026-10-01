#!/usr/bin/env bash
set -Eeuo pipefail

# Enter a Ghost Kali rootfs environment from Termux, proot-distro, or another Linux host.

ROOTFS="${1:-.}"
[[ -d "$ROOTFS" ]] || { printf 'Rootfs not found: %s\n' "$ROOTFS" >&2; exit 1; }

# Prefer proot for portability (works in Termux and nested environments)
if command -v proot >/dev/null 2>&1; then
  exec proot -0 \
    -r "$ROOTFS" \
    -b /dev \
    -b /proc \
    -b /sys \
    -b /sdcard 2>/dev/null || exec /bin/sh
fi

# Fallback to chroot (requires native Linux and root)
if [[ $EUID -eq 0 ]] && command -v chroot >/dev/null 2>&1; then
  exec chroot "$ROOTFS" /bin/bash -i
fi

printf 'Cannot enter rootfs: proot or chroot not available.\n' >&2
exit 1

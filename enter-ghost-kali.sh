#!/usr/bin/env bash
set -Eeuo pipefail

# Enter a Ghost Kali rootfs environment from Termux, proot-distro, or another Linux host.
# Default rootfs is kept inside this repository so it stays self-contained.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOTFS="${1:-$REPO_DIR/rootfs}"

[[ -d "$ROOTFS" ]] || { printf 'Rootfs not found: %s\n' "$ROOTFS" >&2; printf 'Create it with: %s/build-kali-rootfs.sh\n' "$REPO_DIR" >&2; exit 1; }

# Prefer proot for portability (works in Termux and nested environments)
if command -v proot >/dev/null 2>&1; then
  exec proot -0 \
    -r "$ROOTFS" \
    -b /dev \
    -b /proc \
    -b /sys \
    -b /sdcard \
    /bin/bash -i
fi

# Fallback to chroot (requires native Linux and root)
if [[ $EUID -eq 0 ]] && command -v chroot >/dev/null 2>&1; then
  exec chroot "$ROOTFS" /bin/bash -i
fi

printf 'Cannot enter rootfs: proot or chroot not available.\n' >&2
exit 1

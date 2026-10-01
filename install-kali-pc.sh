#!/usr/bin/env bash
set -Eeuo pipefail

# Ghost Kali — official Kali Linux PC installer-media builder
# This script does NOT install Kali over the running Windows system.
# It downloads the official Kali Installer ISO, verifies its SHA256,
# and optionally writes it to a removable USB device.

KALI_BASE="https://cdimage.kali.org/current"
ISO="kali-linux-2026.2-installer-amd64.iso"
SUMS="SHA256SUMS"
USB=""

die(){ echo "[!] $*" >&2; exit 1; }
need(){ command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }

usage(){
  cat <<'EOF'
Ghost Kali — official Kali bare-metal installer media

Usage:
  ./install-kali-pc.sh download
  ./install-kali-pc.sh verify
  ./install-kali-pc.sh usb /dev/sdX

The USB operation ERASES the selected removable drive.
It never guesses a disk and never writes to the system disk automatically.

After creating the USB:
  1. Reboot the PC.
  2. Boot from the USB.
  3. Select Kali's Installer.
  4. For Windows replacement, choose Guided - use entire disk.
  5. For dual boot, preserve Windows and use the appropriate free-space option.

EOF
}

download(){
  need curl
  mkdir -p "$HOME/ghost-kali-images"
  cd "$HOME/ghost-kali-images"
  curl -fL --retry 3 -o "$ISO" "$KALI_BASE/$ISO"
  curl -fL --retry 3 -o "$SUMS" "$KALI_BASE/$SUMS"
  echo "[+] Downloaded official Kali Installer ISO."
}

verify(){
  need sha256sum
  cd "$HOME/ghost-kali-images"
  [[ -f "$ISO" && -f "$SUMS" ]] || die "Run: $0 download"
  grep " $ISO$" "$SUMS" | sha256sum -c -
}

write_usb(){
  need dd
  need lsblk
  USB="$1"
  [[ -b "$USB" ]] || die "$USB is not a block device."
  [[ "$USB" != "/" && "$USB" != "/dev/" ]] || die "Refusing invalid target."
  echo
  echo "WARNING: EVERYTHING on $USB will be erased."
  lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS "$USB" || true
  read -r -p "Type ERASE $USB to continue: " answer
  [[ "$answer" == "ERASE $USB" ]] || die "Cancelled."
  cd "$HOME/ghost-kali-images"
  sudo umount "$USB"* 2>/dev/null || true
  sudo dd if="$ISO" of="$USB" bs=4M status=progress conv=fsync
  sync
  echo "[+] Bootable Kali USB created."
}

case "${1:-}" in
  download) download ;;
  verify) verify ;;
  usb) [[ $# -eq 2 ]] || die "Usage: $0 usb /dev/sdX"; write_usb "$2" ;;
  *) usage ;;
esac

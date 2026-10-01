#!/usr/bin/env bash
set -euo pipefail

# Ghost Kali native installer guard.
# Does not guess images or erase/flash partitions.

KALI_GET="https://www.kali.org/get-kali/"
NH_PRO="https://www.kali.org/docs/nethunter-pro/"

echo "Ghost Kali — Native Kali / NetHunter Pro installer"
echo "Official Kali images only; no blind flashing."

ARCH="$(uname -m)"
MODEL="$(getprop ro.product.model 2>/dev/null || true)"
DEVICE="$(getprop ro.product.device 2>/dev/null || true)"

echo "Architecture: $ARCH"
echo "Model:        ${MODEL:-unknown}"
echo "Codename:     ${DEVICE:-unknown}"
echo

case "$DEVICE" in
  beryllium|enchilada|fajita|spacewar|polaris|axolotl|blueline|fp5|pinephone|pinephonepro)
    echo "A Kali NetHunter Pro target may exist for this codename."
    ;;
  *)
    echo "No built-in native target is declared for this device."
    echo "Check the official supported-device list before flashing:"
    echo "  $NH_PRO"
    exit 2
    ;;
esac

command -v fastboot >/dev/null 2>&1 || {
  echo "fastboot is required for supported Qualcomm/Android targets."
  echo "Run the device-specific installer from a computer with Android platform-tools."
  exit 3
}

echo
echo "Safety stop: this generic script does not flash partitions."
echo "Download the exact official image from:"
echo "  $KALI_GET"
echo "Verify its SHA256 checksum against Kali's published checksum."
echo "Then follow the device-specific NetHunter Pro instructions."

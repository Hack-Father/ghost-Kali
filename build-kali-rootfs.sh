#!/usr/bin/env bash
set -euo pipefail

# Ghost Kali rootfs build script
# A Kali-derived custom build approach that uses official upstream sources.
# This script does not bundle proprietary or closed-source code.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$REPO_DIR/build-rootfs}"
DISTRO="kali"
SUITE="kali-rolling"
ARCH="$(dpkg --print-architecture 2>/dev/null || echo amd64)"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

if ! command -v debootstrap >/dev/null 2>&1; then
  echo "Installing debootstrap..."
  apt-get update
  apt-get install -y debootstrap
fi

mkdir -p "$TARGET_DIR"

cat > /tmp/ghost-kali-sources.list <<EOF
# Official Kali apt sources
# These are upstream sources used to build a Kali-derived environment.
deb http://http.kali.org/kali $SUITE main contrib non-free non-free-firmware
# Debian source packages are enabled here to support source-backed builds.
deb-src http://http.kali.org/kali $SUITE main contrib non-free non-free-firmware
EOF

cp /tmp/ghost-kali-sources.list /etc/apt/sources.list.d/ghost-kali.sources.list

apt-get update

# Build a minimal Kali rootfs using upstream Kali packages.
# This is the supported source-backed model.
debootstrap \
  --arch "$ARCH" \
  --variant=minbase \
  --components=main,contrib,non-free,non-free-firmware \
  "$SUITE" "$TARGET_DIR" http://http.kali.org/kali

# Install common Kali utilities if the user wants them in the rootfs.
# These packages are fetched from upstream Kali package repositories.
chroot "$TARGET_DIR" /bin/bash -lc "apt-get update && apt-get install -y --no-install-recommends python3 git curl wget nmap whois john hashcat netcat-openbsd tcpdump openssl"

# Provide a source availability path for users who need upstream source packages.
mkdir -p "$TARGET_DIR/usr/local/share/ghost-kali"
cat > "$TARGET_DIR/usr/local/share/ghost-kali/README.txt" <<EOF
Ghost Kali build notes

This rootfs is built from official Kali package repositories.
Source code can be retrieved using apt-get source for the relevant packages.
Please preserve Kali and upstream licensing notices and source availability.
EOF

# Optionally fetch source packages for the default installed tools.
# This keeps the build source-backed and transparent.
chroot "$TARGET_DIR" /bin/bash -lc "apt-get source nmap || true"
chroot "$TARGET_DIR" /bin/bash -lc "apt-get source john || true"

cat <<EOF
Ghost Kali rootfs build complete.

Build output: $TARGET_DIR

This build is a Kali-derived custom rootfs based on upstream Kali package sources.
If you redistribute it, preserve the official Kali notices and GPL source availability.

Next steps:
  1. Customize the rootfs with your branding or scripts.
  2. Install additional packages from the official Kali repositories.
  3. Keep upstream licensing files and source availability intact.
EOF

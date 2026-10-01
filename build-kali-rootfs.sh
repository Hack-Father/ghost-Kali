#!/usr/bin/env bash
set -euo pipefail

# Ghost Kali
# Powered by official Kali Linux repositories and upstream Kali package sources.
# This script is a Kali-derived custom build helper and does not replace the official Kali project.

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
# Official Kali Linux upstream apt sources
# These are the canonical upstream repositories for a Kali-derived build.
deb http://http.kali.org/kali $SUITE main contrib non-free non-free-firmware
deb-src http://http.kali.org/kali $SUITE main contrib non-free non-free-firmware
EOF

cp /tmp/ghost-kali-sources.list /etc/apt/sources.list.d/ghost-kali.sources.list
apt-get update

# Create a minimal Kali-based rootfs from official Kali package sources.
debootstrap \
  --arch "$ARCH" \
  --variant=minbase \
  --components=main,contrib,non-free,non-free-firmware \
  "$SUITE" "$TARGET_DIR" http://http.kali.org/kali

# Install common utilities from the official Kali repos.
chroot "$TARGET_DIR" /bin/bash -lc "apt-get update && apt-get install -y --no-install-recommends python3 git curl wget nmap whois john hashcat netcat-openbsd tcpdump openssl"

mkdir -p "$TARGET_DIR/usr/local/share/ghost-kali"
cat > "$TARGET_DIR/usr/local/share/ghost-kali/README.txt" <<EOF
Ghost Kali rootfs notes

This rootfs is powered by official Kali Linux upstream repositories.
The underlying sources remain the official Kali Linux project and package archives.
Please preserve upstream advisories, licensing files, and source availability notices.
EOF

# Fetch source packages where relevant to support source-backed builds.
chroot "$TARGET_DIR" /bin/bash -lc "apt-get source nmap || true"
chroot "$TARGET_DIR" /bin/bash -lc "apt-get source john || true"

cat <<EOF
Ghost Kali rootfs build complete.

Build output: $TARGET_DIR

This build is powered by official Kali Linux upstream sources and uses the official Kali repositories.
If you redistribute it, preserve Kali licensing and source availability notices.

Next steps:
  1. Customize the rootfs with your own scripts or branding.
  2. Install additional packages from the official Kali repositories.
  3. Keep upstream license and source notices intact.
EOF

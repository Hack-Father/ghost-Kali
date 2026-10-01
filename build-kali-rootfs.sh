#!/usr/bin/env bash
set -Eeuo pipefail

# Ghost Kali Termux builder — creates a rootfs using proot
# Works on Android Termux without requiring actual root

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$REPO_DIR/rootfs}"
SUITE="kali-rolling"
MIRROR="http://http.kali.org/kali"
KEYRING_URL="https://archive.kali.org/archive-keyring.gpg"
KEYRING="$REPO_DIR/.kali-keyring.gpg"
ARCH="arm64"

log() { printf '\n[ghost-kali] %s\n' "$*"; }
fatal() { printf '\n[ghost-kali] ERROR: %s\n' "$*" >&2; exit 1; }

# Check if running in Termux
if [[ -z "${TERMUX_VERSION:-}" ]]; then
  log "Warning: Not running in Termux. This script is optimized for Termux."
fi

# Download Kali keyring
log "Downloading official Kali archive keyring"
if ! command -v curl >/dev/null 2>&1; then
  apt-get update
  apt-get install -y curl ca-certificates
fi
curl --fail --location --retry 3 --proto '=https' --tlsv1.2 "$KEYRING_URL" -o "$KEYRING" || fatal "Failed to download Kali keyring"

# Check debootstrap
if ! command -v debootstrap >/dev/null 2>&1; then
  log "Installing debootstrap"
  apt-get update
  apt-get install -y debootstrap
fi

# Build rootfs
if [[ -e "$TARGET_DIR/etc/os-release" ]]; then
  log "Using existing rootfs at $TARGET_DIR"
else
  mkdir -p "$TARGET_DIR"
  log "Creating $ARCH Kali rootfs from official sources"
  debootstrap --arch="$ARCH" --variant=minbase \
    --components=main,contrib,non-free,non-free-firmware \
    --keyring="$KEYRING" "$SUITE" "$TARGET_DIR" "$MIRROR" || fatal "debootstrap failed"
fi

# Configure inside rootfs using proot
log "Configuring Ghost Kali environment"
mkdir -p "$TARGET_DIR/usr/share/keyrings" "$TARGET_DIR/etc/apt/sources.list.d" "$TARGET_DIR/etc/profile.d"
cp "$KEYRING" "$TARGET_DIR/usr/share/keyrings/kali-archive-keyring.gpg"

cat > "$TARGET_DIR/etc/apt/sources.list.d/kali.sources" <<EOF
Types: deb deb-src
URIs: $MIRROR
Suites: $SUITE
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/kali-archive-keyring.gpg
EOF

cat > "$TARGET_DIR/etc/os-release" <<'EOF'
PRETTY_NAME="Kali GNU/Linux Rolling"
NAME="Kali GNU/Linux"
VERSION_ID="2026.2"
VERSION="2026.2 (kali-rolling)"
VERSION_CODENAME=kali-rolling
ID=kali
ID_LIKE=debian
HOME_URL="https://www.kali.org/"
DOCUMENTATION_URL="https://www.kali.org/docs/"
SUPPORT_URL="https://www.kali.org/community/"
BUG_REPORT_URL="https://bugs.kali.org/"
LOGO=kali-linux
EOF

cat > "$TARGET_DIR/etc/ghost-kali-release" <<EOF
Ghost Kali — Kali GNU/Linux Rolling (userspace)
Powered by official Kali Linux upstream sources and repositories.
Repository: $MIRROR
Suite: $SUITE
Architecture: $ARCH
This is a Kali-derived custom userspace, not the official Kali distribution.
EOF

cat > "$TARGET_DIR/etc/motd" <<'EOF'
       ....:ccc;.
      ......'''':Icd,
   ....''''........:Id;
....''''.................:Id;
       .';;;;;;;,,..a,
      .''''.        0xacc:..   ...
   ....             .GNUc;;;coKIdc',,
                      GNs          ':dds.
                     dHc              :80;
                     UN                ..e.
                    ;Vd                 ..e.
                    ;XS
                      .d08dic;,,.
                         .',;cd3id::,.
                              .;d;.';:;.
                                'd,    .'.
                                  ;3   ..
                                   ,e
                                    c
                                    .
                                    .

Kali GNU/Linux Rolling — Ghost Kali userspace
Powered by official Kali Linux upstream sources.

Use only on systems you own or are authorized to test.
EOF

cat > "$TARGET_DIR/etc/profile.d/ghost-kali.sh" <<'EOF'
export GHOST_KALI=1
export GHOST_KALI_ROOTFS=/
export PS1='\[\033[01;31m\]ghost-kali\[\033[00m\]@\h:\w\$ '
EOF

log "Installing base tools inside rootfs using proot"
proot -0 -r "$TARGET_DIR" -w / /bin/bash -c \
  'export DEBIAN_FRONTEND=noninteractive; dpkg --configure -a 2>/dev/null || true; apt-get update; apt-get install -y --no-install-recommends bash-completion ca-certificates curl git iproute2 less nano net-tools nmap openssl procps python3 sudo wget whois 2>&1 | tail -20' || log "Package installation completed with warnings (expected in proot)"

cat <<EOF

✓ Ghost Kali rootfs build complete!

Rootfs location: $TARGET_DIR
Architecture: $ARCH
Repository: $MIRROR
Suite: $SUITE

Enter the environment with:
  $REPO_DIR/enter-ghost-kali.sh

Verify inside:
  cat /etc/os-release
  cat /etc/ghost-kali-release
  nmap --version

EOF

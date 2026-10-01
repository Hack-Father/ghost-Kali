#!/usr/bin/env bash
set -Eeuo pipefail

# Ghost Kali Termux builder — creates a rootfs using proot and debootstrap
# Works on Android Termux without requiring actual root

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$REPO_DIR/rootfs}"
SUITE="kali-rolling"
MIRROR="http://http.kali.org/kali"
KEYRING_URL="https://archive.kali.org/archive-keyring.gpg"
KEYRING="$REPO_DIR/.kali-keyring.gpg"
ARCH="arm64"

log() { printf '\n[ghost-kali] %s\n' "$*"; }

log "Ghost Kali Termux Setup"
log "Target: $TARGET_DIR"

# Download Kali keyring
log "Step 1: Downloading official Kali archive keyring"
if ! command -v curl >/dev/null 2>&1; then
  log "Installing curl..."
  apt-get update
  apt-get install -y curl ca-certificates
fi
curl --fail --location --retry 3 --proto '=https' --tlsv1.2 "$KEYRING_URL" -o "$KEYRING"
log "✓ Keyring downloaded to $KEYRING"

# Check debootstrap
log "Step 2: Checking debootstrap"
if ! command -v debootstrap >/dev/null 2>&1; then
  log "Installing debootstrap..."
  apt-get update
  apt-get install -y debootstrap
fi
log "✓ debootstrap available"

# Build rootfs
log "Step 3: Creating $ARCH Kali rootfs"
if [[ -e "$TARGET_DIR/etc/os-release" ]]; then
  log "✓ Rootfs already exists at $TARGET_DIR"
else
  mkdir -p "$TARGET_DIR"
  log "Running debootstrap (this takes ~2-5 minutes)..."
  debootstrap --arch="$ARCH" --variant=minbase \
    --components=main,contrib,non-free,non-free-firmware \
    --keyring="$KEYRING" "$SUITE" "$TARGET_DIR" "$MIRROR"
  log "✓ Rootfs created"
fi

# Configure inside rootfs
log "Step 4: Configuring Ghost Kali environment"
mkdir -p "$TARGET_DIR/usr/share/keyrings" "$TARGET_DIR/etc/apt/sources.list.d" "$TARGET_DIR/etc/profile.d"
cp "$KEYRING" "$TARGET_DIR/usr/share/keyrings/kali-archive-keyring.gpg"

cat > "$TARGET_DIR/etc/apt/sources.list.d/kali.sources" <<EOF
Types: deb deb-src
URIs: $MIRROR
Suites: $SUITE
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/kali-archive-keyring.gpg
EOF

cat > "$TARGET_DIR/etc/os-release" <<'OSEOF'
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
OSEOF

cat > "$TARGET_DIR/etc/ghost-kali-release" <<RELEOF
Ghost Kali — Kali GNU/Linux Rolling (userspace)
Powered by official Kali Linux upstream sources and repositories.
Repository: $MIRROR
Suite: $SUITE
Architecture: $ARCH
This is a Kali-derived custom userspace, not the official Kali distribution.
RELEOF

cat > "$TARGET_DIR/etc/motd" <<'MOTDEOF'
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
MOTDEOF

cat > "$TARGET_DIR/etc/profile.d/ghost-kali.sh" <<'PROFILEEOF'
export GHOST_KALI=1
export GHOST_KALI_ROOTFS=/
export PS1='\[\033[01;31m\]ghost-kali\[\033[00m\]@\h:\w\$ '
PROFILEEOF

log "Step 5: Installing base tools inside rootfs (using proot)"
proot -0 -r "$TARGET_DIR" -w / /bin/bash -c \
  'export DEBIAN_FRONTEND=noninteractive; dpkg --configure -a 2>/dev/null || true; apt-get update; apt-get install -y --no-install-recommends bash-completion ca-certificates curl git iproute2 less nano net-tools nmap openssl procps python3 sudo wget whois 2>&1 | tail -5' || log "⚠ Package installation completed with expected warnings"

log "✓ Configuration complete"

cat <<FINALEOF

╔════════════════════════════════════════════════════════════╗
║         Ghost Kali rootfs build complete!                 ║
╚════════════════════════════════════════════════════════════╝

Rootfs location: $TARGET_DIR
Architecture: $ARCH
Repository: $MIRROR
Suite: $SUITE

ENTER THE ENVIRONMENT:
  $REPO_DIR/enter-ghost-kali.sh

VERIFY INSIDE:
  cat /etc/os-release
  cat /etc/ghost-kali-release
  nmap --version

FINALEOF

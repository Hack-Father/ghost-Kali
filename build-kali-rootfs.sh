#!/usr/bin/env bash
set -Eeuo pipefail

# Ghost Kali — a Kali-derived userspace powered by official Kali Linux sources.
# This script does not replace the official Kali Linux or NetHunter projects.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$REPO_DIR/build-rootfs}"
SUITE="kali-rolling"
MIRROR="http://http.kali.org/kali"
KEYRING_URL="https://archive.kali.org/archive-keyring.gpg"
KEYRING="/usr/share/keyrings/kali-archive-keyring.gpg"
ARCH="$(dpkg --print-architecture 2>/dev/null || echo amd64)"

log() { printf '\n[ghost-kali] %s\n' "$*"; }
fatal() { printf '\n[ghost-kali] ERROR: %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || fatal "Run this script as root (for example: sudo $0 /root/ghost-kali-rootfs)."

if ! command -v debootstrap >/dev/null 2>&1; then
  log "Installing debootstrap and dependencies"
  apt-get update
  apt-get install -y --no-install-recommends debootstrap ca-certificates curl wget
fi
command -v curl >/dev/null 2>&1 || apt-get install -y --no-install-recommends curl ca-certificates

log "Installing the official Kali archive keyring"
install -d -m 0755 "$(dirname "$KEYRING")"
curl --fail --location --retry 3 --proto '=https' --tlsv1.2 "$KEYRING_URL" -o "$KEYRING"
chmod 0644 "$KEYRING"

if [[ -e "$TARGET_DIR/etc/os-release" ]]; then
  log "Using existing rootfs at $TARGET_DIR"
else
  mkdir -p "$TARGET_DIR"
  log "Creating $ARCH Kali rootfs from official sources"
  debootstrap --arch="$ARCH" --variant=minbase \
    --components=main,contrib,non-free,non-free-firmware \
    --keyring="$KEYRING" "$SUITE" "$TARGET_DIR" "$MIRROR"
fi

install -d -m 0755 "$TARGET_DIR/usr/share/keyrings" "$TARGET_DIR/etc/apt/sources.list.d"
install -m 0644 "$KEYRING" "$TARGET_DIR$KEYRING"
cat > "$TARGET_DIR/etc/apt/sources.list.d/kali.sources" <<EOF
Types: deb deb-src
URIs: $MIRROR
Suites: $SUITE
Components: main contrib non-free non-free-firmware
Signed-By: $KEYRING
EOF

log "Installing Ghost Kali base environment"
run_target() {
  if command -v proot >/dev/null 2>&1; then
    proot -0 -r "$TARGET_DIR" -b /dev -b /proc -b /sys -w / /bin/bash -c "$1"
  else
    chroot "$TARGET_DIR" /bin/bash -c "$1"
  fi
}
run_target 'export DEBIAN_FRONTEND=noninteractive; dpkg --configure -a || true; apt-get update; apt-get install -y --no-install-recommends bash-completion ca-certificates curl git iproute2 less nano net-tools nmap openssl procps python3 sudo wget whois' || log "Package configuration is incomplete; finish with apt-get -f install inside the rootfs."

log "Configuring Ghost Kali identity"
install -d -m 0755 "$TARGET_DIR/usr/local/share/ghost-kali" "$TARGET_DIR/etc/profile.d"
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
cat > "$TARGET_DIR/etc/ghost-kali-release" <<'EOF'
Ghost Kali — Kali GNU/Linux Rolling (userspace)
Powered by official Kali Linux upstream sources and repositories.
Repository: http://http.kali.org/kali
Suite: kali-rolling
This is a Kali-derived custom userspace, not the official Kali distribution.
EOF
cat > "$TARGET_DIR/etc/motd" <<'EOF'

  _  __     _ _   _   _  __ _   _
 | |/ /__ _| | | (_) | |/ /| | | |
 | ' // _` | | | | | | ' / | | | |
 | . \ (_| | | | | | . \ | |_| |
 |_|\_\__,_|_|_| |_| |_|\_\___|

Kali GNU/Linux Rolling — Ghost Kali userspace
Powered by official Kali Linux upstream sources.

Use only on systems you own or are authorized to test.

EOF
cat > "$TARGET_DIR/etc/profile.d/ghost-kali.sh" <<'EOF'
export GHOST_KALI=1
export GHOST_KALI_ROOTFS=/
export PS1='\[\033[01;31m\]ghost-kali\[\033[00m\]@\h:\w\$ '
EOF
cat > "$TARGET_DIR/usr/local/share/ghost-kali/README.txt" <<EOF
Ghost Kali userspace
Identity: Kali GNU/Linux Rolling
Repository: $MIRROR
Suite: $SUITE
Architecture: $ARCH

This userspace is powered by official Kali Linux sources and does not replace
the official Kali Linux or Kali NetHunter projects. Preserve upstream
attribution, license files, and source-availability obligations.
EOF

cat <<EOF

Ghost Kali rootfs build complete.
Rootfs: $TARGET_DIR
Architecture: $ARCH
Repository: $MIRROR
Enter with: $REPO_DIR/enter-ghost-kali.sh $TARGET_DIR
EOF

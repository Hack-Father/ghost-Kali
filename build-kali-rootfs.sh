#!/usr/bin/env bash
set -Eeuo pipefail

# Ghost Kali — a Kali-derived userspace powered by official Kali Linux sources.
# This script does not replace the official Kali Linux or NetHunter projects.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$REPO_DIR/build-rootfs}"
SUITE="kali-rolling"
MIRROR="https://http.kali.org/kali"
KEYRING_URL="https://archive.kali.org/archive-keyring.gpg"
KEYRING="/usr/share/keyrings/kali-archive-keyring.gpg"
ARCH="$(dpkg --print-architecture 2>/dev/null || echo amd64)"

log() { printf '\n[ghost-kali] %s\n' "$*"; }
fatal() { printf '\n[ghost-kali] ERROR: %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || fatal "Run this script as root (for example: sudo $0 /root/ghost-kali-rootfs)."
command -v debootstrap >/dev/null 2>&1 || {
  log "Installing debootstrap"
  apt-get update
  apt-get install -y --no-install-recommends debootstrap ca-certificates curl wget
}
command -v curl >/dev/null 2>&1 || apt-get install -y --no-install-recommends curl ca-certificates

install -d -m 0755 "$(dirname "$KEYRING")"
log "Installing the official Kali archive keyring"
curl --fail --location --retry 3 --proto '=https' --tlsv1.2 "$KEYRING_URL" -o "$KEYRING"
chmod 0644 "$KEYRING"

# Keep the host configuration scoped to Kali and explicitly signed by the official key.
install -d -m 0755 /etc/apt/sources.list.d
cat > /etc/apt/sources.list.d/ghost-kali.list <<EOF
# Official Kali Linux upstream repository for Ghost Kali
# Remove this file if you do not want Kali packages on the host.
deb [signed-by=$KEYRING] $MIRROR $SUITE main contrib non-free non-free-firmware
deb-src [signed-by=$KEYRING] $MIRROR $SUITE main contrib non-free non-free-firmware
EOF

log "Checking the signed Kali repository"
apt-get update -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/ghost-kali.list \
  -o Dir::Etc::sourceparts=- -o APT::Get::List-Cleanup=0

if [[ -e "$TARGET_DIR/etc/os-release" ]]; then
  log "Using existing rootfs at $TARGET_DIR"
else
  mkdir -p "$TARGET_DIR"
  log "Creating $ARCH Kali rootfs from official sources"
  debootstrap \
    --arch="$ARCH" \
    --variant=minbase \
    --components=main,contrib,non-free,non-free-firmware \
    --keyring="$KEYRING" \
    "$SUITE" "$TARGET_DIR" "$MIRROR"
fi

# Make the key available inside the target before any apt operation.
install -d -m 0755 "$TARGET_DIR/usr/share/keyrings"
install -m 0644 "$KEYRING" "$TARGET_DIR$KEYRING"

cat > "$TARGET_DIR/etc/apt/sources.list.d/kali.sources" <<EOF
Types: deb deb-src
URIs: $MIRROR
Suites: $SUITE
Components: main contrib non-free non-free-firmware
Signed-By: $KEYRING
EOF

# Do not depend on host chroot support: this also works in a normal Debian VM.
run_target() { chroot "$TARGET_DIR" /usr/bin/env -i HOME=/root PATH=/usr/sbin:/usr/bin:/sbin:/bin "/bin/bash" -c "$*"; }

log "Installing the base Ghost Kali environment"
run_target 'export DEBIAN_FRONTEND=noninteractive; apt-get update; apt-get install -y --no-install-recommends bash-completion ca-certificates curl git iproute2 less nano net-tools nmap openssl procps python3 sudo wget whois'

install -d -m 0755 "$TARGET_DIR/usr/local/share/ghost-kali" "$TARGET_DIR/etc/profile.d"
cat > "$TARGET_DIR/etc/motd" <<'EOF'
\033[1;31m\n  _  __     _ _   _   _  __ _   _\n | |/ /__ _| | | (_) | |/ /| | | |\n | ' // _` | | | | | | ' / | | | |\n | . \u005c (_| | | | | | | . \u005c | |_| |\n |_|\u005c_\__,_|_|_| |_| |_|\u005c_\u005c_\__, |\n                              |___/\n\033[0m
Kali GNU/Linux Rolling — Ghost Kali userspace
Powered by official Kali Linux upstream sources.

Use only on systems you own or are authorized to test.
EOF
cat > "$TARGET_DIR/etc/profile.d/ghost-kali.sh" <<'EOF'
# Ghost Kali shell identity; Kali attribution is intentionally preserved.
export GHOST_KALI=1
export GHOST_KALI_ROOTFS=/
export PS1='\[\033[01;31m\]ghost-kali\[\033[00m\]@\h:\w\$ '
EOF
cat > "$TARGET_DIR/usr/local/share/ghost-kali/README.txt" <<EOF
Ghost Kali is a Kali-derived userspace powered by official Kali Linux sources.
Identity: Kali GNU/Linux Rolling (Ghost Kali userspace)
Repository: $MIRROR
Suite: $SUITE
Architecture: $ARCH

This is not the official Kali Linux or Kali NetHunter distribution. Preserve
upstream attribution, license files, and source-availability obligations.
EOF

log "Writing environment metadata"
run_target 'printf "Kali GNU/Linux Rolling (Ghost Kali userspace)\\n" > /etc/ghost-kali-release'

cat <<EOF

Ghost Kali rootfs build complete.

Rootfs: $TARGET_DIR
Architecture: $ARCH
Repository: $MIRROR

Enter it with:
  $REPO_DIR/enter-ghost-kali.sh $TARGET_DIR

Verify inside:
  cat /etc/os-release
  cat /etc/ghost-kali-release
EOF

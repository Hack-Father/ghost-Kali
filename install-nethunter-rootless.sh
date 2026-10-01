#!/data/data/com.termux/files/usr/bin/bash
set -eu

# Ghost Kali Android helper: delegates the userspace installation to Kali's
# official NetHunter Rootless installer. This does not root the device.

readonly OFFICIAL_INSTALLER='https://offs.ec/2MceZWr'
readonly installer="$HOME/install-nethunter-termux"

printf '%s\n' 'Ghost Kali - Kali NetHunter Rootless setup'
printf '%s\n' 'This installs a rootless Kali userspace and does not unlock or root Android.'

command -v pkg >/dev/null 2>&1 || {
    echo 'Run this script inside Termux.' >&2
    exit 1
}

pkg update -y
pkg install -y wget

printf '%s\n' 'Downloading the official Kali NetHunter Rootless installer...'
wget --https-only --secure-protocol=TLSv1_2 -O "$installer" "$OFFICIAL_INSTALLER"
test -s "$installer" || {
    echo 'The installer download was empty; aborting.' >&2
    exit 1
}

chmod 700 "$installer"
printf '%s\n' 'Starting the official installer. Follow its prompts:'
"$installer"

rm -f "$installer"

# Install Kali's official tool metapackage inside the NetHunter Kali userspace.
# Set GHOST_KALI_ALL_TOOLS=0 before running to skip the large everything set.
if command -v nethunter >/dev/null 2>&1 && [[ "${GHOST_KALI_ALL_TOOLS:-1}" == "1" ]]; then
    printf '%s\\n' 'Installing Kali Linux Everything inside NetHunter. This can require tens of GB of storage and take a long time.'
    nethunter -c 'apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y kali-linux-everything'
fi

# Install the custom Ghost Kali banner into the NetHunter user's shell.
REPO_DIR="$PWD"
BANNER_FILE="$REPO_DIR/kali-banner.txt"
if [[ -f "$BANNER_FILE" ]] && command -v nethunter >/dev/null 2>&1; then
    printf '%s\n' 'Installing Ghost Kali banner into NetHunter...'
    BANNER_B64="$(base64 -w 0 "$BANNER_FILE")"
    nethunter -c "echo '$BANNER_B64' | base64 -d > /home/kali/.ghost-banner && touch /home/kali/.bashrc && grep -qxF 'cat ~/.ghost-banner' /home/kali/.bashrc || printf '\\ncat ~/.ghost-banner\\n' >> /home/kali/.bashrc"
fi

# Automatically start the existing Ghost Kali menu inside NetHunter.
if command -v nethunter >/dev/null 2>&1; then
    printf '%s\n' 'Configuring Ghost Kali automatic startup...'
    nethunter -c "touch /home/kali/.bashrc && grep -qxF 'GHOST_KALI_MENU_STARTED=1' /home/kali/.bashrc || cat >> /home/kali/.bashrc <<'EOF'
# Ghost Kali automatic startup
if [[ $- == *i* ]] && [[ -z "$GHOST_KALI_MENU_STARTED" ]] && [[ -f "$HOME/ghost-Kali/kali-menu.sh" ]]; then
    export GHOST_KALI_MENU_STARTED=1
    bash "$HOME/ghost-Kali/kali-menu.sh"
fi
EOF"
fi

# Automatically launch the installed Kali NetHunter Rootless session.
if command -v nethunter >/dev/null 2>&1; then
    printf '%s\n' 'Launching Kali NetHunter Rootless...'
    exec nethunter
elif command -v nh >/dev/null 2>&1; then
    printf '%s\n' 'Launching Kali NetHunter Rootless...'
    exec nh
else
    printf '%s\n' 'NetHunter was installed, but its launcher is not yet on PATH.'
    printf '%s\n' 'Restart Termux, then run: nethunter'
fi

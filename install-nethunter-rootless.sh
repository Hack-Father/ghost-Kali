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
printf '%s\n' 'When installation finishes, use the nethunter command shown by the installer.'
printf '%s\n' 'Then clone Ghost Kali inside the Kali session, not the Termux host.'

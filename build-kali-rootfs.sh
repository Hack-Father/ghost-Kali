#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Rebuild/install the Kali Linux userspace from official Kali sources.
# This intentionally delegates the rootfs installation to Kali's official
# NetHunter Rootless installer instead of maintaining a private rootfs.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Ghost Kali uses the official Kali Linux userspace."
echo "[+] Reinstall/rebuild it with the official Kali NetHunter Rootless flow."
echo

exec "$SCRIPT_DIR/install-nethunter-rootless.sh"

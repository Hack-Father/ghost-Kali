# Ghost Kali NetHunter on Android

The supported non-root approach is **Kali NetHunter Rootless**. It runs a Kali userspace inside Termux using `proot`; it does not provide kernel-level features such as monitor mode, HID attacks, or external Wi-Fi injection.

## Requirements

- Android device with sufficient storage (10 GB or more recommended)
- Termux installed from F-Droid or the official Termux GitHub releases
- Reliable Wi-Fi or mobile data
- Battery and storage available during installation

Do not install Termux from an untrusted APK mirror, and do not mix Termux apps from different sources.

## Install

In Termux, run:

```bash
pkg update && pkg upgrade -y
pkg install -y wget
wget -O install-nethunter-rootless.sh https://raw.githubusercontent.com/Hack-Father/ghost-Kali/main/install-nethunter-rootless.sh
chmod +x install-nethunter-rootless.sh
./install-nethunter-rootless.sh
```

The script downloads the official Kali NetHunter Rootless installer from the Kali endpoint, verifies that it downloaded, and starts it. Follow the prompts shown by the official installer.

After installation, launch Kali with the command printed by the installer, commonly:

```bash
nethunter
```

Use the command-line session for Ghost Kali:

```bash
git clone https://github.com/Hack-Father/ghost-Kali.git
cd ghost-Kali
```

Install packages from inside the Kali userspace with `apt`, rather than using Termux's `pkg` commands.

## Rooted devices

For rooted devices and advanced NetHunter capabilities, use the official Kali NetHunter images and documentation. Device-specific kernels and images are required; this repository does not provide or flash kernels.

## Remove the environment

Use the uninstall command documented by the NetHunter installer. Do not delete random Termux directories while a session is running.

## Legal notice

Use scanning, exploitation, password-auditing, and wireless tools only against systems and networks you own or have written permission to test.

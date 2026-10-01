# Testing Ghost Kali in Termux

This repository can be tested as a userspace rootfs in Termux. It is not a full Android kernel or NetHunter installation.

## 1. Prepare Termux

Use Termux from F-Droid or the official Termux releases, then run:

```bash
pkg update && pkg upgrade -y
pkg install -y git proot-distro
proot-distro install debian
proot-distro login debian
```

## 2. Build the rootfs

Inside the Debian proot environment:

```bash
apt update
apt install -y git ca-certificates curl debootstrap

git clone https://github.com/Hack-Father/ghost-Kali.git
cd ghost-Kali
chmod +x build-kali-rootfs.sh enter-ghost-kali.sh
sudo ./build-kali-rootfs.sh /root/ghost-kali-rootfs
```

The builder downloads the official Kali archive keyring over HTTPS, passes it to `debootstrap`, and configures Kali with an explicit `Signed-By` key. It does not disable APT signature verification.

If nested `chroot` is unavailable in the Debian proot environment, build the rootfs on a normal Linux machine or use the official Kali NetHunter Rootless workflow for Android. The generated rootfs can still be entered with `proot`.

## 3. Enter and verify Kali

```bash
./enter-ghost-kali.sh /root/ghost-kali-rootfs
```

Inside the environment:

```bash
cat /etc/os-release
cat /etc/ghost-kali-release
printf '%s\n' "$GHOST_KALI"
```

Expected identity includes:

```text
ID=kali
VERSION_CODENAME=kali-rolling
Kali GNU/Linux Rolling (Ghost Kali userspace)
```

The shell displays a Kali-style banner and prompt, but this remains a Ghost Kali-derived userspace powered by official Kali packages—not the official Kali distribution or NetHunter application.

## Limitations

Proot does not provide kernel capabilities. Raw packet capture, monitor mode, wireless injection, USB hardware access, and other kernel-dependent features may not work. Use official Kali NetHunter documentation for supported Android devices and features.

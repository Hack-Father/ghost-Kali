# Ghost Kali

Ghost Kali is a custom presentation and tooling layer built on the **official Kali Linux userspace**.

## Architecture

Ghost Kali does **not** maintain a private Linux distribution or a modified Kali rootfs.

On Android/Termux, the project uses Kali's official **NetHunter Rootless** installation flow. Kali publishes the rootfs images and the NetHunter Rootless installer through its own infrastructure.

That means:

- Kali Linux supplies the Linux userspace.
- Kali's official repositories supply packages and updates.
- Kali's official NetHunter Rootless project supplies the Android/Termux launcher and PRoot integration.
- Ghost Kali supplies the optional menu, banner and convenience scripts.

This is a real Kali Linux userspace, but on an unrooted Android phone it is **not a native Linux kernel installation**. Android's kernel remains underneath it.

## Commands

From Termux:

```bash
cd ~/ghost-Kali
./install.sh
```

Enter the Kali userspace without the Ghost menu:

```bash
nethunter
```

or:

```bash
./enter-ghost-kali.sh
```

Launch the Ghost Kali menu manually:

```bash
ghost-kali
```

The menu is deliberately **not** added to `/home/kali/.bashrc`. This keeps `nethunter` as a normal Kali shell.

## Updating Kali

Inside Kali:

```bash
apt update
apt full-upgrade
```

Kali's rolling-release documentation recommends `apt full-upgrade` because package transitions can require dependency changes.

## Tool installation

Install only the toolsets you actually need. For example:

```bash
apt update
apt install -y nmap sqlmap metasploit-framework hydra nikto
```

Kali also provides official metapackages such as `kali-linux-core`, `kali-linux-default`, and `kali-linux-everything`. The Everything metapackage is intentionally very large, so Ghost Kali does not install it automatically.

## Official sources

- Kali Linux: https://www.kali.org/
- Kali documentation: https://www.kali.org/docs/
- Kali NetHunter: https://www.kali.org/docs/nethunter/
- NetHunter Rootless source: https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-rootless
- Official Kali rootfs mirror: https://kali.download/nethunter-images/current/rootfs/

## Responsible use

Use security tools only against systems you own or have explicit authorization to test.

## License

MIT for Ghost Kali's own project files. Kali Linux and NetHunter components retain their respective upstream licenses and notices.


## Platform support

Ghost Kali keeps the underlying Kali environment separate from its optional menu.

- **Windows:** official Kali Linux WSL 2.
- **Existing Kali PC:** Ghost is installed as an optional menu; Kali remains the OS.
- **Native mobile:** only when an official Kali/NetHunter Pro image and compatible kernel exist for the device.
- **Android without native support:** official NetHunter Rootless is the fallback. It is a Kali userspace on Android, not native Kali.

For Windows, use `install-windows-wsl.ps1 -InstallGhost` from an elevated PowerShell. Kali's official WSL documentation recommends WSL 2 and provides `wsl --install kali-linux`.

For a computer that should boot Kali itself, use the official Kali ISO from the Kali download page and install it as bare metal or dual boot. Ghost Kali should never overwrite Windows partitions automatically.

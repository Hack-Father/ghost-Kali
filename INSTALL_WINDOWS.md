# Ghost Kali on Windows

Ghost Kali uses the **official Kali Linux distribution**. On Windows, the supported integration is Kali Linux under **WSL 2**.

WSL 2 uses a real Linux kernel managed by WSL. It is not Termux/PRoot and it does not use the Android NetHunter userspace. Kali documents WSL 2 as its preferred WSL architecture. citeturn0search5

## Install

Open **PowerShell as Administrator** in the cloned repository:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install-windows-wsl.ps1 -InstallGhost
```

The script:

1. Updates WSL.
2. Sets WSL 2 as the default.
3. Installs the official `kali-linux` WSL distribution if it is missing.
4. Optionally installs Ghost Kali's menu as `ghost-kali`.

Enter normal Kali later with:

```powershell
wsl -d kali-linux
```

Inside Kali:

```bash
cat /etc/os-release
```

You should see `Kali GNU/Linux Rolling`.

Launch the optional Ghost interface only when wanted:

```bash
ghost-kali
```

The menu does **not** replace the Kali shell and is not automatically launched.

## Native Windows warning

WSL 2 is not the same thing as replacing Windows with Kali Linux. If you want Kali to be the computer's booted operating system, download an official Kali ISO from Kali and install it as a bare-metal/dual-boot system. Do not use a Ghost script to overwrite Windows partitions.

Kali provides official installation images through its Get Kali page. citeturn0search3

## Mobile platforms

Android is handled separately. Standard NetHunter Rootless is a Kali userspace running on Android, not a native Kali kernel/OS. Kali documents Rootless, Lite and full NetHunter as separate editions. citeturn0search1

For supported ARM64 mobile devices, Kali NetHunter Pro is the pure-Kali option. Kali currently lists supported devices such as PinePhone/Pro, Poco F1, OnePlus 6/6T, Nothing Phone 1, Xiaomi Mi MIX 2S and SHIFT6mq. citeturn0search0

Ghost Kali must not flash a phone unless an official/device-compatible Kali image and kernel have been verified.

## Security

Use Kali and its security tools only on systems you own or are explicitly authorized to test.

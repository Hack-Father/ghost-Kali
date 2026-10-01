# Ghost Kali on Windows

Ghost Kali is distributed on Windows through supported Kali Linux environments rather than as a separate replacement operating system.

## Recommended: WSL 2

Requirements:

- Windows 10 version 2004 or newer, or Windows 11
- Administrator access
- Virtualization enabled in firmware
- At least 10 GB free storage

Open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install-windows-wsl.ps1
```

The script enables WSL, installs the Kali distribution, and opens Kali. Inside Kali, clone Ghost Kali and install only the tools you need:

```bash
git clone https://github.com/Hack-Father/ghost-Kali.git
cd ghost-Kali
chmod +x install.sh
./install.sh
```

Start it later with:

```powershell
wsl -d kali-linux
```

## Alternative: VirtualBox

1. Install Oracle VirtualBox from its official website.
2. Download the official Kali Linux VirtualBox image from `kali.org/get-kali/`.
3. Import the `.ova` file in VirtualBox.
4. Allocate at least 4 GB RAM and 2 CPU cores if available.
5. Start Kali, update it, and clone this repository.

```bash
sudo apt update && sudo apt full-upgrade -y
git clone https://github.com/Hack-Father/ghost-Kali.git
```

## Notes

- WSL does not provide monitor mode or USB Wi-Fi features by default.
- Do not run offensive tools against systems without explicit authorization.
- This project does not redistribute the Kali operating system; it provides setup helpers and documentation.

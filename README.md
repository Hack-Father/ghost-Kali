# Ghost Kali - Kali Linux for Termux

A complete Kali Linux environment for Termux with essential penetration testing and security tools.

## Features

- Full Kali Linux tools suite
- Optimized for Termux environment
- Networking tools (nmap, netcat, etc.)
- Exploitation frameworks (Metasploit, SQLMap)
- Password cracking tools (hashcat, john)
- Reconnaissance tools (curl, wget, whois)
- Wireless tools (aircrack-ng, wireshark)
- Web application testing tools (BurpSuite, OWASP ZAP)

## Prerequisites

- Termux application installed
- At least 2GB free storage
- Internet connection for installation

## Installation

### 1. Update Termux
```bash
pkg update
pkg upgrade
```

### 2. Install Python & Essential Tools
```bash
pkg install python3 python3-pip curl wget git openssh
```

### 3. Run the Setup Script
```bash
git clone https://github.com/Hack-Father/ghost-Kali.git
cd ghost-Kali
bash install.sh
```

## Available Tools

### Reconnaissance
- `nmap` - Network mapper
- `whois` - Domain information
- `curl` - Data transfer tool
- `wget` - File downloader

### Exploitation
- `sqlmap` - SQL injection testing
- `metasploit` - Penetration testing framework

### Password Tools
- `john` - Password cracker
- `hashcat` - GPU-based password cracking

### Networking
- `netcat` - Network utility
- `tcpdump` - Network analysis
- `aircrack-ng` - Wireless security

## Usage

```bash
# Access the Kali environment
kali-start

# Run individual tools
nmap -sV target.com
sqlmap -u "http://target.com" --dbs
john hashfile.txt
```

## Quick Command Reference

```bash
# Network scanning
nmap -A -sV target.com

# Web vulnerability scanning
sqlmap -u "URL" --dbs --batch

# Password cracking
john --wordlist=wordlist.txt hashfile.txt
hashcat -m 0 -a 0 hash.txt wordlist.txt

# DNS enumeration
whois domain.com
nslookup target.com
```

## Disclaimer

⚠️ **IMPORTANT**: This tool is for authorized security testing and educational purposes only. Unauthorized access to computer systems is illegal. Always obtain proper authorization before conducting security tests.

## Contributing

Contributions are welcome! Feel free to submit pull requests with improvements and new tools.

## License

MIT License - See LICENSE file for details

## Support

For issues and questions, open a GitHub issue or contact the maintainer.

---

**Stay ethical, stay legal, and always get permission before testing!**

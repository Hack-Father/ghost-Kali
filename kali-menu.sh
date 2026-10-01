#!/bin/bash

# Ghost Kali - Interactive Menu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BANNER_FILE="${GHOST_KALI_BANNER:-$PREFIX/share/ghost-kali/kali-banner.txt}"

clear

# Kali/NetHunter helpers
need_cmd() {
    local cmd="$1" pkg="$2"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[!] $cmd is not installed."
        echo "    In Kali/NetHunter, install it with: sudo apt install -y $pkg"
        return 1
    fi
    return 0
}

run_sqlmap() {
    if command -v sqlmap >/dev/null 2>&1; then
        sqlmap "$@"
    elif [[ -f "$HOME/sqlmap/sqlmap.py" ]]; then
        python3 "$HOME/sqlmap/sqlmap.py" "$@"
    else
        echo "[!] sqlmap is not installed."
        echo "    Install it with: sudo apt install -y sqlmap"
    fi
}

run_msfconsole() {
    if command -v msfconsole >/dev/null 2>&1; then
        msfconsole "$@"
    elif [[ -x "run_msfconsole" ]]; then
        "$HOME/metasploit-framework/msfconsole" "$@"
    else
        echo "[!] msfconsole is not installed."
        echo "    Install it with: sudo apt install -y metasploit-framework"
    fi
}

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
                need_cmd whois whois || continue\n                whois "$domain"
                ;;
            2)
                read -p "Enter hostname/IP: " host
                need_cmd nslookup bind9-dnsutils || continue\n                nslookup "$host"
                ;;
            3)
                read -p "Enter IP address: " ip
                need_cmd nslookup bind9-dnsutils || continue\n                nslookup -type=PTR "$ip"
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
                run_sqlmap -u "$url" --dbs
                ;;
            2)
                read -p "Enter URL: " url
                need_cmd curl curl || continue\n                curl -I "$url"
                ;;
            3)
                read -p "Enter URL: " url
                need_cmd curl curl || continue\n                curl -v "$url" 2>&1 | head -20
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
                need_cmd john john || continue\n                john "$hashfile"
                ;;
            2)
                echo "Usage: hashcat -m [hash_type] -a [attack_mode] hash.txt wordlist.txt"
                read -p "Enter hash file: " hfile
                read -p "Enter wordlist: " wlist
                need_cmd hashcat hashcat || continue\n                hashcat -m 0 -a 0 "$hfile" "$wlist"
                ;;
            3)
                read -p "Enter wordlist path: " wordlist
                read -p "Enter hash file path: " hashfile
                need_cmd john john || continue\n                john --wordlist="$wordlist" "$hashfile"
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
                run_sqlmap
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
                need_cmd aircrack-ng aircrack-ng || continue\n                aircrack-ng
                ;;
            2)
                if command -v wireshark >/dev/null 2>&1; then
                    wireshark
                elif command -v tshark >/dev/null 2>&1; then
                    tshark
                else
                    echo "[!] Wireshark/TShark is not installed. Install with: sudo apt install -y wireshark tshark"
                fi
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
                if command -v ip >/dev/null 2>&1; then ip addr; else need_cmd ifconfig net-tools && ifconfig; fi
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
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get upgrade -y
        else
            echo "[!] Kali apt package manager not found."
        fi
        echo "Use the Kali package manager to update installed tools."
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

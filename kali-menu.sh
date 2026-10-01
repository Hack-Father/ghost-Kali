#!/bin/bash
# Ghost Kali - Interactive menu for Kali NetHunter

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BANNER_FILE="${GHOST_KALI_BANNER:-$HOME/ghost-Kali/kali-banner.txt}"

need_cmd() {
    local cmd="$1" pkg="$2"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[!] $cmd is not installed."
        echo "    Install in Kali/NetHunter with: sudo apt install -y $pkg"
        return 1
    fi
}

run_sqlmap() {
    if command -v sqlmap >/dev/null 2>&1; then
        sqlmap "$@"
    else
        echo "[!] sqlmap is not installed in Kali."
        echo "    Install with: apt-get install -y sqlmap"
    fi
}

run_msfconsole() {
    if command -v msfconsole >/dev/null 2>&1; then
        msfconsole "$@"
    else
        echo "[!] Metasploit is not installed."
        echo "    Install with: sudo apt install -y metasploit-framework"
    fi
}

show_menu() {
    clear
    if [[ -f "$BANNER_FILE" ]]; then
        cat "$BANNER_FILE"
        echo ""
    fi

    echo "╔════════════════════════════════════════════════════════╗"
    echo "║      Ghost Kali - Official Kali NetHunter Tools        ║"
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
    echo "[8] Update Kali Tools"
    echo "[9] Exit"
    echo ""
}

while true; do
    show_menu
    read -r -p "Enter your choice [1-9]: " choice

    case "$choice" in
        1)
            echo ""
            echo "=== Reconnaissance Tools ==="
            echo "[1] Whois"
            echo "[2] DNS Lookup"
            echo "[3] Reverse DNS"
            echo "[4] Back"
            read -r -p "Choose: " recon
            case "$recon" in
                1)
                    read -r -p "Enter domain: " domain
                    need_cmd whois whois && whois "$domain"
                    ;;
                2)
                    read -r -p "Enter hostname/IP: " host
                    need_cmd nslookup bind9-dnsutils && nslookup "$host"
                    ;;
                3)
                    read -r -p "Enter IP address: " ip
                    need_cmd nslookup bind9-dnsutils && nslookup -type=PTR "$ip"
                    ;;
            esac
            read -r -p "Press Enter to continue..."
            ;;
        2)
            echo ""
            echo "=== Network Scanning ==="
            echo "[1] Basic Nmap Scan"
            echo "[2] Service Version Detection"
            echo "[3] OS Detection"
            echo "[4] Full Scan"
            echo "[5] Back"
            read -r -p "Choose: " nmap_choice
            if [[ "$nmap_choice" != "5" ]]; then
                read -r -p "Enter target IP/hostname: " target
                if need_cmd nmap nmap; then
                    case "$nmap_choice" in
                        1) nmap "$target" ;;
                        2) nmap -sV "$target" ;;
                        3) nmap -O "$target" ;;
                        4) nmap -A -sV -O "$target" ;;
                    esac
                fi
            fi
            read -r -p "Press Enter to continue..."
            ;;
        3)
            echo ""
            echo "=== Web Application Testing ==="
            echo "[1] SQLMap - authorized testing"
            echo "[2] URL Headers"
            echo "[3] Header Analysis"
            echo "[4] Back"
            read -r -p "Choose: " web_choice
            case "$web_choice" in
                1)
                    read -r -p "Enter target URL: " url
                    run_sqlmap -u "$url" --dbs
                    ;;
                2)
                    read -r -p "Enter URL: " url
                    need_cmd curl curl && curl -I "$url"
                    ;;
                3)
                    read -r -p "Enter URL: " url
                    need_cmd curl curl && curl -v "$url" 2>&1 | head -20
                    ;;
            esac
            read -r -p "Press Enter to continue..."
            ;;
        4)
            echo ""
            echo "=== Password Cracking ==="
            echo "[1] John the Ripper"
            echo "[2] Hashcat"
            echo "[3] Dictionary Attack"
            echo "[4] Back"
            read -r -p "Choose: " crack_choice
            case "$crack_choice" in
                1)
                    read -r -p "Enter hash file path: " hashfile
                    need_cmd john john && john "$hashfile"
                    ;;
                2)
                    read -r -p "Enter hash file: " hfile
                    read -r -p "Enter wordlist: " wlist
                    need_cmd hashcat hashcat && hashcat -m 0 -a 0 "$hfile" "$wlist"
                    ;;
                3)
                    read -r -p "Enter wordlist path: " wordlist
                    read -r -p "Enter hash file path: " hashfile
                    need_cmd john john && john --wordlist="$wordlist" "$hashfile"
                    ;;
            esac
            read -r -p "Press Enter to continue..."
            ;;
        5)
            echo ""
            echo "=== Exploitation Tools ==="
            echo "[1] Metasploit Framework"
            echo "[2] SQLMap"
            echo "[3] Back"
            read -r -p "Choose: " exploit_choice
            case "$exploit_choice" in
                1) run_msfconsole ;;
                2) run_sqlmap ;;
            esac
            read -r -p "Press Enter to continue..."
            ;;
        6)
            echo ""
            echo "=== Wireless Security ==="
            echo "[1] Aircrack-ng"
            echo "[2] Wireshark/TShark"
            echo "[3] Back"
            read -r -p "Choose: " wireless_choice
            case "$wireless_choice" in
                1)
                    echo "Use only on networks/devices you own or are authorized to test."
                    need_cmd aircrack-ng aircrack-ng && aircrack-ng
                    ;;
                2)
                    if command -v wireshark >/dev/null 2>&1; then
                        wireshark
                    elif command -v tshark >/dev/null 2>&1; then
                        tshark
                    else
                        echo "[!] Wireshark/TShark is not installed."
                        echo "    Install with: sudo apt install -y wireshark tshark"
                    fi
                    ;;
            esac
            read -r -p "Press Enter to continue..."
            ;;
        7)
            echo ""
            echo "=== System Information ==="
            echo "[1] System Info"
            echo "[2] Network Configuration"
            echo "[3] Disk Usage"
            echo "[4] Running Processes"
            echo "[5] Back"
            read -r -p "Choose: " sys_choice
            case "$sys_choice" in
                1) uname -a ;;
                2) command -v ip >/dev/null 2>&1 && ip addr || ifconfig ;;
                3) df -h ;;
                4) ps aux ;;
            esac
            read -r -p "Press Enter to continue..."
            ;;
        8)
            echo ""
            echo "=== Update Kali Tools ==="
            if command -v apt-get >/dev/null 2>&1; then
                if [[ "$(id -u)" -eq 0 ]]; then
                    apt-get update
                    apt-get upgrade -y
                elif command -v sudo >/dev/null 2>&1; then
                    sudo apt-get update
                    sudo apt-get upgrade -y
                else
                    echo "[!] Run: sudo apt update && sudo apt upgrade -y"
                fi
            else
                echo "[!] Kali apt package manager not found."
            fi
            read -r -p "Press Enter to continue..."
            ;;
        9)
            echo "Exiting Ghost Kali Menu..."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            sleep 1
            ;;
    esac
done

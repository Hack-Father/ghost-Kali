#!/bin/bash

# Ghost Kali - Complete Kali Linux Tools Installation Script for Termux
# This script installs a comprehensive suite of Kali Linux tools optimized for Termux

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
}

print_section() {
    echo -e "\n${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

print_info() {
    echo -e "${YELLOW}[i] $1${NC}"
}

# Main installation
main() {
    print_header "Ghost Kali - Complete Kali Linux Tools Installation"
    
    print_info "This will install ALL major Kali Linux tools (estimated time: 45-90 minutes)"
    read -p "Continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    
    # Update system
    print_section "Updating Termux packages"
    pkg update -y
    pkg upgrade -y
    print_success "System updated"
    
    # Install core build tools
    print_section "Installing core build tools and development packages"
    pkg install -y \
        build-essential \
        clang \
        make \
        cmake \
        pkg-config \
        autoconf \
        automake \
        libtool \
        libssl-dev \
        libffi-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        tk-dev \
        python3 \
        python3-dev \
        python3-pip \
        git \
        curl \
        wget \
        openssh \
        vim \
        nano \
        tmux \
        screen
    print_success "Build tools installed"
    
    # Install Python 3 and upgrade pip
    print_section "Upgrading Python pip and installing base Python packages"
    python3 -m pip install --upgrade pip setuptools wheel
    pip install --upgrade pip
    print_success "Python environment ready"
    
    # Information Gathering & Reconnaissance Tools
    print_section "Installing Information Gathering Tools"
    pkg install -y \
        whois \
        dnsutils \
        bind-tools \
        host
    pip install \
        requests \
        beautifulsoup4 \
        lxml \
        urllib3 \
        pycurl
    print_success "Reconnaissance tools installed"
    
    # Vulnerability Scanning Tools
    print_section "Installing Vulnerability Scanning Tools"
    pkg install -y nmap
    print_success "Nmap installed"
    
    # Network Tools
    print_section "Installing Network Analysis Tools"
    pkg install -y \
        net-tools \
        netcat \
        tcpdump \
        traceroute \
        mtr \
        telnet \
        inetutils
    print_success "Network tools installed"
    
    # Web Application Testing
    print_section "Installing Web Application Testing Tools"
    pip install \
        requests \
        beautifulsoup4 \
        lxml \
        paramiko \
        pycryptodome \
        requests-toolbelt \
        selenium \
        scrapy
    print_success "Web testing libraries installed"
    
    # SQLMap Installation
    print_section "Installing SQLMap (SQL Injection Testing)"
    if [ -d "$HOME/sqlmap" ]; then
        print_info "SQLMap already exists, updating..."
        cd $HOME/sqlmap && git pull
    else
        git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git $HOME/sqlmap
    fi
    chmod +x $HOME/sqlmap/sqlmap.py
    print_success "SQLMap installed"
    
    # Password Cracking Tools
    print_section "Installing Password Cracking Tools"
    pkg install -y \
        john \
        hashcat
    pip install \
        pycryptodome \
        bcrypt \
        passlib
    print_success "Password cracking tools installed"
    
    # Wireless Security Tools
    print_section "Installing Wireless Security Tools"
    pkg install -y \
        aircrack-ng \
        wireshark \
        tshark
    print_success "Wireless tools installed"
    
    # Cryptography Tools
    print_section "Installing Cryptography Tools"
    pkg install -y \
        openssl \
        gnupg
    pip install \
        pycryptodome \
        cryptography \
        pyopenssl
    print_success "Cryptography tools installed"
    
    # Metasploit Framework
    print_section "Installing Metasploit Framework"
    if [ -d "$HOME/metasploit-framework" ]; then
        print_info "Metasploit already exists, updating..."
        cd $HOME/metasploit-framework && git pull
    else
        git clone --depth 1 https://github.com/rapid7/metasploit-framework.git $HOME/metasploit-framework
    fi
    cd $HOME/metasploit-framework
    pkg install -y ruby ruby-dev
    gem install bundler
    bundle install 2>/dev/null || true
    chmod +x $HOME/metasploit-framework/msfconsole
    print_success "Metasploit Framework installed"
    
    # Burp Suite (Community Edition alternative - OWASP ZAP)
    print_section "Installing OWASP ZAP (Web Security Scanner)"
    if [ -d "$HOME/zaproxy" ]; then
        print_info "OWASP ZAP already exists"
    else
        git clone --depth 1 https://github.com/zaproxy/zaproxy.git $HOME/zaproxy
    fi
    print_success "OWASP ZAP installed"
    
    # Hydra (Brute Force Tool)
    print_section "Installing Hydra (Password Brute Forcing)"
    if [ -d "$HOME/hydra" ]; then
        print_info "Hydra already exists"
    else
        git clone --depth 1 https://github.com/vanhauser-thc/thc-hydra.git $HOME/hydra
        cd $HOME/hydra
        ./configure && make && make install 2>/dev/null || true
    fi
    print_success "Hydra installed"
    
    # Nikto (Web Server Scanner)
    print_section "Installing Nikto (Web Server Scanner)"
    if [ -d "$HOME/nikto" ]; then
        print_info "Nikto already exists"
    else
        git clone --depth 1 https://github.com/sullo/nikto.git $HOME/nikto
        chmod +x $HOME/nikto/program/nikto.pl
    fi
    print_success "Nikto installed"
    
    # Dirb/Dirbuster Alternative
    print_section "Installing Directory Brute Forcing Tools"
    pip install \
        dirbuster \
        dirb
    print_success "Directory scanning tools installed"
    
    # Nessus Alternative - OpenVAS
    print_section "Installing Vulnerability Assessment Tools"
    pip install \
        vulners \
        exploit-db
    print_success "Vulnerability assessment tools installed"
    
    # Burp Suite Alternatives
    print_section "Installing Additional Web Testing Tools"
    pip install \
        w3af \
        sqlmap \
        xsscrapy
    print_success "Web testing tools installed"
    
    # Reverse Engineering Tools
    print_section "Installing Reverse Engineering Tools"
    pip install \
        capstone \
        keystone-engine \
        radare2-python
    print_success "Reverse engineering tools installed"
    
    # Exploitation Development
    print_section "Installing Exploitation Development Tools"
    pip install \
        pwntools \
        ropgadget \
        angr
    print_success "Exploitation tools installed"
    
    # Steganography Tools
    print_section "Installing Steganography Tools"
    pip install \
        pillow \
        stegano
    print_success "Steganography tools installed"
    
    # Forensics Tools
    print_section "Installing Digital Forensics Tools"
    pip install \
        volatility \
        yara-python \
        pyopenssl
    print_success "Forensics tools installed"
    
    # Proxy and Interception
    print_section "Installing Proxy Tools"
    pip install \
        mitmproxy \
        requests[socks]
    print_success "Proxy tools installed"
    
    # Enumeration Tools
    print_section "Installing Enumeration Tools"
    pip install \
        pycurl \
        dnspython \
        ipaddress
    print_success "Enumeration tools installed"
    
    # Social Engineering Toolkit
    print_section "Installing Social Engineering Framework"
    if [ -d "$HOME/SET" ]; then
        print_info "Social Engineering Toolkit already exists"
    else
        git clone --depth 1 https://github.com/trustedsec/social-engineer-toolkit $HOME/SET
        cd $HOME/SET
        python3 -m pip install -r requirements.txt 2>/dev/null || true
    fi
    print_success "Social Engineering Toolkit installed"
    
    # Update pip packages
    print_section "Updating all Python packages"
    pip install --upgrade \
        requests \
        beautifulsoup4 \
        lxml \
        urllib3 \
        paramiko \
        pycryptodome \
        requests-toolbelt \
        selenium \
        scrapy \
        dnspython \
        pycurl
    print_success "Python packages updated"
    
    # Create comprehensive startup script
    print_section "Creating startup scripts and aliases"
    
    mkdir -p $PREFIX/bin
    mkdir -p $PREFIX/share/ghost-kali

    # Install the banner alongside the Ghost Kali menu so every installation has it.
    if [ -f "$HOME/ghost-Kali/kali-banner.txt" ]; then
        cp "$HOME/ghost-Kali/kali-banner.txt" "$PREFIX/share/ghost-kali/kali-banner.txt"
    fi
    
    # Main menu
    cat > $PREFIX/bin/kali-menu.sh << 'EOF'
#!/bin/bash
# Ghost Kali Interactive Menu

clear

# Display the Ghost Kali banner from the repository when available.
BANNER_FILE="${GHOST_KALI_BANNER:-$PREFIX/share/ghost-kali/kali-banner.txt}"
if [[ -f "$BANNER_FILE" ]]; then
    cat "$BANNER_FILE"
    echo ""
fi

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Ghost Kali - Complete Kali Linux Suite for Termux     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "MAIN CATEGORIES:"
echo "[1]  Reconnaissance & Information Gathering"
echo "[2]  Vulnerability Scanning"
echo "[3]  Web Application Testing"
echo "[4]  Password Cracking & Brute Force"
echo "[5]  Exploitation & Post-Exploitation"
echo "[6]  Wireless Security & Network Analysis"
echo "[7]  Reverse Engineering & Forensics"
echo "[8]  Social Engineering"
echo "[9]  Encryption & Cryptography"
echo "[10] System Information & Utilities"
echo "[11] Update All Tools"
echo "[12] Exit"
echo ""
read -p "Select category [1-12]: " choice

case $choice in
    1)
        echo "=== Reconnaissance Tools ==="
        echo "[1] Whois Lookup     [2] DNS Lookup      [3] Traceroute"
        echo "[4] Reverse DNS      [5] MX Records      [6] Back"
        read -p "Choose: " tool
        case $tool in
            1)
                read -p "Domain: " domain
                whois $domain
                ;;
            2)
                read -p "Host: " host
                nslookup $host
                ;;
            3)
                read -p "Target: " target
                traceroute $target
                ;;
            4)
                read -p "IP: " ip
                nslookup -type=PTR $ip
                ;;
            5)
                read -p "Domain: " domain
                nslookup -type=MX $domain
                ;;
        esac
        ;;
    2)
        echo "=== Vulnerability Scanning ==="
        echo "[1] Nmap Basic        [2] Nmap Service Detection"
        echo "[3] Nmap OS Detection [4] Nmap Full Scan"
        echo "[5] Nikto Web Scan    [6] Back"
        read -p "Choose: " tool
        read -p "Target: " target
        case $tool in
            1) nmap $target ;;
            2) nmap -sV $target ;;
            3) nmap -O $target ;;
            4) nmap -A -sV -O -Pn $target ;;
            5) perl $HOME/nikto/program/nikto.pl -h $target ;;
        esac
        ;;
    3)
        echo "=== Web Application Testing ==="
        echo "[1] SQLMap          [2] OWASP ZAP"
        echo "[3] HTTP Headers    [4] URL Fuzzing"
        echo "[5] Back"
        read -p "Choose: " tool
        case $tool in
            1)
                read -p "URL: " url
                python3 $HOME/sqlmap/sqlmap.py -u "$url" --dbs
                ;;
            2)
                echo "Starting OWASP ZAP..."
                cd $HOME/zaproxy && ./gradlew run 2>/dev/null || echo "Run: cd $HOME/zaproxy && bash build.sh"
                ;;
            3)
                read -p "URL: " url
                curl -I $url
                ;;
            4)
                read -p "URL: " url
                python3 $HOME/nikto/program/nikto.pl -h $url
                ;;
        esac
        ;;
    4)
        echo "=== Password Cracking Tools ==="
        echo "[1] John the Ripper [2] Hashcat"
        echo "[3] Hydra Brute Force [4] Back"
        read -p "Choose: " tool
        case $tool in
            1)
                read -p "Hash file: " file
                john $file
                ;;
            2)
                read -p "Hash file: " file
                read -p "Wordlist: " wordlist
                hashcat -m 0 -a 0 $file $wordlist
                ;;
            3)
                read -p "Target: " target
                read -p "Service (ssh/http/ftp): " service
                read -p "Username: " user
                read -p "Wordlist: " wordlist
                cd $HOME/hydra && ./hydra -l $user -P $wordlist $target $service
                ;;
        esac
        ;;
    5)
        echo "=== Exploitation Framework ==="
        echo "[1] Metasploit Framework"
        echo "[2] Pwntools"
        echo "[3] SQLMap"
        echo "[4] Back"
        read -p "Choose: " tool
        case $tool in
            1) $HOME/metasploit-framework/msfconsole ;;
            2) python3 ;;
            3) python3 $HOME/sqlmap/sqlmap.py ;;
        esac
        ;;
    6)
        echo "=== Network & Wireless Tools ==="
        echo "[1] Aircrack-ng    [2] TCPDump"
        echo "[3] Wireshark      [4] Netcat"
        echo "[5] Back"
        read -p "Choose: " tool
        case $tool in
            1) aircrack-ng ;;
            2) tcpdump -i any ;;
            3) wireshark ;;
            4) nc -lnvp 4444 ;;
        esac
        ;;
    7)
        echo "=== Reverse Engineering ==="
        echo "[1] Pwntools    [2] Radare2"
        echo "[3] Capstone    [4] Back"
        read -p "Choose: " tool
        case $tool in
            1) python3 ;;
            2) echo "Install: pkg install radare2" ;;
            3) python3 ;;
        esac
        ;;
    8)
        echo "=== Social Engineering ==="
        echo "[1] Social Engineering Toolkit"
        echo "[2] Back"
        read -p "Choose: " tool
        case $tool in
            1) cd $HOME/SET && python3 setoolkit ;;
        esac
        ;;
    9)
        echo "=== Cryptography Tools ==="
        echo "[1] OpenSSL    [2] GnuPG"
        echo "[3] Back"
        read -p "Choose: " tool
        case $tool in
            1) openssl ;;
            2) gpg ;;
        esac
        ;;
    10)
        echo "=== System Information ==="
        echo "[1] System Info  [2] Network Config"
        echo "[3] Disk Usage   [4] Processes"
        echo "[5] Back"
        read -p "Choose: " tool
        case $tool in
            1) uname -a ;;
            2) ifconfig ;;
            3) df -h ;;
            4) ps aux ;;
        esac
        ;;
    11)
        echo "Updating all tools..."
        pkg update -y && pkg upgrade -y
        cd $HOME/sqlmap && git pull
        cd $HOME/metasploit-framework && git pull
        cd $HOME/hydra && git pull
        cd $HOME/nikto && git pull
        cd $HOME/zaproxy && git pull
        pip install --upgrade pip
        pip install --upgrade requests beautifulsoup4 lxml urllib3 paramiko pycryptodome
        echo "All tools updated!"
        ;;
    12)
        echo "Exiting Kali..."
        exit 0
        ;;
esac

read -p "Press Enter to continue..."
bash $PREFIX/bin/kali-menu.sh
EOF
    
    chmod +x $PREFIX/bin/kali-menu.sh

    # Keep the installed menu synchronized with the repository copy when available.
    if [ -f "$HOME/ghost-Kali/kali-menu.sh" ]; then
        cp "$HOME/ghost-Kali/kali-menu.sh" "$PREFIX/bin/kali-menu.sh"
        chmod +x "$PREFIX/bin/kali-menu.sh"
    fi
    print_success "Menu created"
    
    # Update bashrc with aliases
    cat >> $HOME/.bashrc << 'EOF'

# Ghost Kali Aliases
alias kali-menu="bash $PREFIX/bin/kali-menu.sh"
alias kali-tools="kali-menu"
alias sqlmap-start="python3 $HOME/sqlmap/sqlmap.py"
alias msf="$HOME/metasploit-framework/msfconsole"
alias hydra-start="cd $HOME/hydra && ./hydra"
alias nikto-scan="perl $HOME/nikto/program/nikto.pl"
alias zaproxy="cd $HOME/zaproxy"
alias set="cd $HOME/SET && python3 setoolkit"
alias nmap-scan="nmap"
alias hashcat-crack="hashcat"
alias john-crack="john"

EOF
    source $HOME/.bashrc
    print_success "Aliases configured"
    
    # Create update script
    cat > $PREFIX/bin/kali-update.sh << 'EOF'
#!/bin/bash
echo "Updating Ghost Kali..."
pkg update -y && pkg upgrade -y
cd $HOME/sqlmap && git pull
cd $HOME/metasploit-framework && git pull && bundle install
cd $HOME/hydra && git pull
cd $HOME/nikto && git pull
cd $HOME/zaproxy && git pull
cd $HOME/SET && git pull
pip install --upgrade pip
pip install --upgrade -r $HOME/sqlmap/requirements.txt 2>/dev/null || true
echo "Update complete!"
EOF
    chmod +x $PREFIX/bin/kali-update.sh
    print_success "Update script created"
    
    # Installation complete
    print_header "✓ Installation Complete!"
    echo -e "${GREEN}Ghost Kali - Complete Kali Linux Suite is now installed!${NC}"
    echo ""
    echo "Available commands:"
    echo -e "  ${CYAN}kali-menu${NC}         - Launch interactive menu"
    echo -e "  ${CYAN}kali-update${NC}       - Update all tools"
    echo -e "  ${CYAN}kali-tools${NC}        - Alias for kali-menu"
    echo -e "  ${CYAN}msf${NC}               - Launch Metasploit"
    echo -e "  ${CYAN}sqlmap-start${NC}      - Launch SQLMap"
    echo -e "  ${CYAN}hydra-start${NC}       - Launch Hydra"
    echo -e "  ${CYAN}nikto-scan${NC}        - Scan with Nikto"
    echo -e "  ${CYAN}set${NC}               - Social Engineering Toolkit"
    echo ""
    echo "Installed Tools Include:"
    echo "  ✓ Reconnaissance (Whois, DNS, Traceroute)"
    echo "  ✓ Network Scanning (Nmap, Netcat, TCPDump)"
    echo "  ✓ Web Testing (SQLMap, Nikto, OWASP ZAP)"
    echo "  ✓ Password Cracking (John, Hashcat, Hydra)"
    echo "  ✓ Exploitation (Metasploit, Pwntools)"
    echo "  ✓ Wireless Security (Aircrack-ng, Wireshark)"
    echo "  ✓ Reverse Engineering (Capstone, Keystone, Pwntools)"
    echo "  ✓ Social Engineering (SET)"
    echo "  ✓ Cryptography (OpenSSL, GnuPG)"
    echo "  ✓ And many more..."
    echo ""
    echo "⚠️  LEGAL DISCLAIMER:"
    echo "These tools are for authorized testing only."
    echo "Unauthorized access to computer systems is ILLEGAL."
    echo "Always obtain written permission before testing!"
    echo ""
    print_success "Ready to use! Type 'kali-menu' to start."
}

# Run installation
main

#!/bin/bash

# Ghost Kali - Kali Linux for Termux Installation Script
# This script installs essential Kali tools in Termux environment

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
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
    print_header "Ghost Kali - Termux Installation"
    
    # Update system
    print_info "Updating Termux packages..."
    pkg update -y
    pkg upgrade -y
    print_success "System updated"
    
    # Install core dependencies
    print_info "Installing core dependencies..."
    pkg install -y \
        build-essential \
        clang \
        make \
        cmake \
        pkg-config \
        libssl-dev \
        libffi-dev \
        python3 \
        python3-pip \
        git \
        curl \
        wget \
        openssh \
        vim \
        nano
    print_success "Core dependencies installed"
    
    # Install networking tools
    print_info "Installing networking tools..."
    pkg install -y \
        net-tools \
        netcat \
        nmap \
        whois \
        dnsutils \
        traceroute \
        mtr \
        tcpdump
    print_success "Networking tools installed"
    
    # Install reconnaissance tools
    print_info "Installing reconnaissance tools..."
    pip install --upgrade pip
    pip install -y \
        requests \
        beautifulsoup4 \
        lxml \
        urllib3
    print_success "Reconnaissance tools installed"
    
    # Install SQLMap
    print_info "Installing SQLMap..."
    if [ -d "$HOME/sqlmap" ]; then
        print_info "SQLMap already exists, updating..."
        cd $HOME/sqlmap && git pull
    else
        git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git $HOME/sqlmap
    fi
    chmod +x $HOME/sqlmap/sqlmap.py
    print_success "SQLMap installed"
    
    # Install password cracking tools
    print_info "Installing password cracking tools..."
    pkg install -y \
        john \
        hashcat
    print_success "Password cracking tools installed"
    
    # Install wireless tools
    print_info "Installing wireless tools..."
    pkg install -y \
        aircrack-ng \
        wireshark
    print_success "Wireless tools installed"
    
    # Install web tools
    print_info "Installing web application testing tools..."
    pip install -y \
        paramiko \
        pycryptodome \
        requests-toolbelt
    print_success "Web tools installed"
    
    # Install Metasploit Framework
    print_info "Installing Metasploit Framework..."
    if [ -d "$HOME/metasploit-framework" ]; then
        print_info "Metasploit already exists, updating..."
        cd $HOME/metasploit-framework && git pull
    else
        git clone --depth 1 https://github.com/rapid7/metasploit-framework.git $HOME/metasploit-framework
    fi
    cd $HOME/metasploit-framework
    gem install bundler
    bundle install
    chmod +x $HOME/metasploit-framework/msfconsole
    print_success "Metasploit Framework installed"
    
    # Create startup script
    print_info "Creating startup script..."
    cat > $PREFIX/bin/kali-start << 'EOF'
#!/bin/bash
echo "═══════════════════════════════════════"
echo "  Welcome to Ghost Kali - Termux Edition"
echo "═══════════════════════════════════════"
echo ""
echo "Available tools:"
echo "  • nmap - Network scanning"
echo "  • sqlmap - SQL injection testing"
echo "  • john - Password cracking"
echo "  • hashcat - GPU password cracking"
echo "  • netcat - Network utility"
echo "  • whois - Domain information"
echo "  • Metasploit - Exploitation framework"
echo ""
echo "Type a command or 'menu' for more options"
echo ""
EOF
    chmod +x $PREFIX/bin/kali-start
    print_success "Startup script created"
    
    # Create aliases
    print_info "Creating command aliases..."
    cat >> $HOME/.bashrc << 'EOF'
# Ghost Kali Aliases
alias sqlmap-start="python3 $HOME/sqlmap/sqlmap.py"
alias msf="$HOME/metasploit-framework/msfconsole"
alias kali-menu="bash $PREFIX/bin/kali-menu.sh"
alias kali-update="bash $PREFIX/bin/kali-update.sh"
alias kali-tools="kali-menu"
EOF
    source $HOME/.bashrc
    print_success "Aliases created"
    
    # Installation complete
    print_header "Installation Complete!"
    print_success "Ghost Kali is now ready to use"
    print_info "Run 'kali-start' to get started"
    print_info "Type 'kali-menu' to see available tools"
    echo ""
    print_info "⚠️  Remember: Use responsibly and legally!"
    echo ""
}

# Run installation
main

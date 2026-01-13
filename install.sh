#!/bin/bash
set -euo pipefail

##
# Bootstrap script to configure a new macOS machine

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_step() { echo -e "\n${GREEN}=== $1 ===${NC}\n"; }
log_info() { echo -e "${YELLOW}[INFO]${NC} $1"; }

echo "======================================"
echo "  macOS Dotfiles Setup"
echo "======================================"

# 1. Install Homebrew and packages (must be first - other scripts may depend on installed packages)
log_step "Installing Homebrew and packages"
"$BIN_DIR/homebrew.sh"

# 2. Set hostname (optional - prompts for hostname)
log_step "Setting hostname"
read -p "Enter hostname (leave blank to skip): " hostname
if [[ -n "$hostname" ]]; then
    "$BIN_DIR/set-hostname.sh" "$hostname"
else
    log_info "Skipping hostname setup"
fi

# 3. Apply macOS defaults
log_step "Applying macOS defaults"
"$BIN_DIR/macosx-defaults.sh"

# 4. Clear the Dock
log_step "Clearing Dock"
"$BIN_DIR/clear-dock.sh"

# 5. Add Thai keyboard layout
log_step "Adding Thai keyboard layout"
"$BIN_DIR/add-thai-layout.sh"

# 6. Configure Brave Browser (optional - only if Brave is installed)
if [[ -d "$HOME/Library/Application Support/BraveSoftware/Brave-Browser" ]]; then
    log_step "Configuring Brave Browser"
    "$BIN_DIR/setup-brave.sh"
else
    log_info "Brave Browser not installed, skipping configuration"
fi

echo
log_step "Setup complete!"
echo "You may need to log out and back in for all changes to take effect."

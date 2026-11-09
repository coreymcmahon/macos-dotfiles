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

# Ensure Homebrew is in PATH for subsequent steps
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. Install Node, global npm packages and (on Intel) CLI tools via Mise
log_step "Installing Mise tools"
"$BIN_DIR/setup-mise.sh"

# 3. Stow dotfiles. This has to come before Herd: its wizard appends to ~/.zshrc,
# and a real file there would make stowing the zsh package fail with a conflict.
log_step "Stowing dotfiles"
"$BIN_DIR/stow.sh"

# 4. Set up Laravel Herd, which provides PHP and Composer. Its first launch runs a
# setup wizard that needs admin rights, so it can't be fully automated.
log_step "Setting up Laravel Herd"
if [[ -x "$HOME/Library/Application Support/Herd/bin/composer" ]]; then
    log_info "Herd already set up"
elif [[ -d /Applications/Herd.app ]]; then
    open -a Herd
    read -r -p "Finish Herd's setup wizard, then press Enter to continue... "
else
    log_info "Herd not installed, skipping"
fi

# 5. Install global PHP tooling (Laravel LSP)
log_step "Installing PHP tooling"
"$BIN_DIR/setup-php-tools.sh"

# 6. Set hostname (uses argument or default from set-hostname.sh)
log_step "Setting hostname"
"$BIN_DIR/set-hostname.sh" "${1:-}"

# 7. Apply macOS defaults
log_step "Applying macOS defaults"
"$BIN_DIR/macosx-defaults.sh"

# 8. Configure the Dock
log_step "Configuring Dock"
"$BIN_DIR/configure-dock.sh"

# 9. Configure input sources
log_step "Configuring input sources"
"$BIN_DIR/configure-input-sources.sh"

# 10. Configure login items
log_step "Configuring login items"
"$BIN_DIR/configure-login-items.sh"

# 11. Configure Brave Browser (optional - only once Brave has created its profile dir)
if [[ -d "$HOME/Library/Application Support/BraveSoftware/Brave-Browser" ]]; then
    log_step "Configuring Brave Browser"
    "$BIN_DIR/setup-brave.sh"
else
    log_info "Brave has no profile yet, skipping. Launch it once, quit, then run bin/setup-brave.sh"
fi

echo
log_step "Setup complete!"
echo "You may need to log out and back in for all changes to take effect."

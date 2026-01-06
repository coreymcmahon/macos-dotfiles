#!/bin/sh

##
# Install Homebrew and packages from Brewfile

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed"
fi

# Install packages from Brewfile
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Installing packages from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

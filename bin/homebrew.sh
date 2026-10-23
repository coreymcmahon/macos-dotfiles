#!/bin/sh

##
# Install Homebrew and packages from Brewfile

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# Homebrew 7+ refuses to load formulae from third-party taps until they are trusted
if brew trust --help >/dev/null 2>&1; then
    brew trust --taps nikitabobko/tap stripe/stripe-cli
fi

# Install packages from Brewfile
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Installing packages from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

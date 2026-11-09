#!/bin/sh

##
# Install Node via Mise. PHP comes from Laravel Herd, not Mise.
#
# On Intel Macs, Mise also provides the CLI tools that Homebrew no longer builds
# bottles for (see the Apple Silicon block in bin/Brewfile), and Mise itself
# comes from its own installer rather than Homebrew.

# Keep in sync with the Apple Silicon block in bin/Brewfile.
INTEL_TOOLS="gh lua-language-server neovim starship stylua tmux"

# The same check as Hardware::CPU in bin/Brewfile: both see the architecture of
# the running process, so they agree even under Rosetta.
is_intel() { [ "$(uname -m)" = x86_64 ]; }

# Mise's installer puts it here, which isn't on PATH until a new shell reads .zshenv
PATH="$HOME/.local/bin:$PATH"

if ! command -v mise >/dev/null 2>&1 && is_intel; then
    echo "Installing mise..."
    curl -fsSL https://mise.run | sh
fi

if ! command -v mise >/dev/null 2>&1; then
    echo "Error: mise is not installed. Install it via Homebrew first."
    exit 1
fi

echo "Installing latest Node.js..."
mise use --global node@latest

if is_intel; then
    echo "Installing CLI tools via mise (Intel)..."
    # shellcheck disable=SC2086
    mise use --global $(printf '%s@latest ' $INTEL_TOOLS) || exit 1
fi


##
# Install global npm packages against the mise-managed Node.
# Replaces the old nvm default-packages mechanism, which mise has no equivalent for.

NPM_GLOBALS="$(dirname "$0")/npm-globals.txt"
if [ -f "$NPM_GLOBALS" ]; then
    # Strip inline comments and blank lines, then flatten to one line.
    packages=$(sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$NPM_GLOBALS" | grep -v '^$' | tr '\n' ' ')
    if [ -n "$packages" ]; then
        echo "Installing global npm packages..."
        # shellcheck disable=SC2086
        mise exec node -- npm install --global $packages
    fi
fi

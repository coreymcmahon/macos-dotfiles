#!/bin/sh

##
# Install Node via Mise. PHP comes from Laravel Herd, not Mise.

if ! command -v mise >/dev/null 2>&1; then
    echo "Error: mise is not installed. Install it via Homebrew first."
    exit 1
fi

echo "Installing latest Node.js..."
mise use --global node@latest


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

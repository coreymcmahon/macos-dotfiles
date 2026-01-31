#!/bin/sh

##
# Install language runtimes via Mise

if ! command -v mise >/dev/null 2>&1; then
    echo "Error: mise is not installed. Install it via Homebrew first."
    exit 1
fi

# The asdf-php plugin hardcodes openssl@1.1 which is no longer available in Homebrew.
# Patch it to use the current openssl instead.
MISE_PHP_PLUGIN="$HOME/.local/share/mise/plugins/php/bin/install"
if [ -f "$MISE_PHP_PLUGIN" ] && grep -q 'openssl@1.1' "$MISE_PHP_PLUGIN"; then
    echo "Patching asdf-php plugin to use current OpenSSL..."
    sed -i '' 's/openssl@1\.1/openssl/g' "$MISE_PHP_PLUGIN"
fi

echo "Installing PHP 8.4..."
mise use --global php@8.4

#echo "Installing PHP 8.5..."
#mise use --global php@8.5

echo "Installing latest Node.js..."
mise use --global node@latest

echo "Installing tree-sitter..."
mise use --global tree-sitter

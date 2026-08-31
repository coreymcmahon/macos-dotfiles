#!/bin/sh

##
# Install global PHP tooling used by the Neovim config.
#
# Composer is expected to already be on PATH. On this setup it comes from
# Laravel Herd; `brew install composer` also works. Missing composer is not
# fatal - the rest of the install should still complete.

if ! command -v composer >/dev/null 2>&1; then
    echo "Warning: composer not found on PATH; skipping PHP tooling."
    echo "         Install Laravel Herd or run: brew install composer"
    echo "         Then re-run: bin/setup-php-tools.sh"
    exit 0
fi

# Laravel LSP (laravel/lsp) - first-party language server providing route names,
# config keys, view paths, translations, middleware aliases, container bindings,
# Inertia/Livewire components and validation rules.
#
# Enabled in nvim as `laravel_lsp` via nvim/.config/nvim/lsp/laravel_lsp.lua,
# which expects the `laravel-lsp` binary on PATH.
echo "Installing Laravel LSP..."
composer global require laravel/lsp --no-interaction

COMPOSER_BIN="$(composer global config bin-dir --absolute --quiet 2>/dev/null)"
if [ -n "$COMPOSER_BIN" ] && ! command -v laravel-lsp >/dev/null 2>&1; then
    echo
    echo "Note: $COMPOSER_BIN is not on your PATH yet."
    echo "      zsh/.zshenv adds it, so open a new shell (or re-stow zsh)."
fi

# Note: Pint (PHP formatter used by conform.nvim) is intentionally NOT installed
# globally - it is a per-project dev dependency, so conform picks up
# vendor/bin/pint from whichever project you're editing.

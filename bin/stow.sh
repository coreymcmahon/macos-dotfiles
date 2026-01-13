#!/bin/bash
set -euo pipefail

##
# Stow dotfiles packages to home directory

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Packages to stow
PACKAGES=(aerospace alacritty starship tmux zsh)

# Check if a package is already stowed by verifying symlinks exist
is_stowed() {
    local pkg="$1"
    local pkg_dir="$DOTFILES_DIR/$pkg"

    # Find the first file/directory in the package and check if it's symlinked
    for item in "$pkg_dir"/.* "$pkg_dir"/*; do
        [[ -e "$item" ]] || continue
        local basename=$(basename "$item")
        [[ "$basename" == "." || "$basename" == ".." ]] && continue

        local target="$HOME/$basename"
        if [[ -L "$target" ]]; then
            local link_target=$(readlink "$target")
            if [[ "$link_target" == *"$pkg/"* ]]; then
                return 0
            fi
        fi
        break
    done
    return 1
}

cd "$DOTFILES_DIR"

for pkg in "${PACKAGES[@]}"; do
    if [[ ! -d "$pkg" ]]; then
        echo "[SKIP] Package '$pkg' not found"
        continue
    fi

    if is_stowed "$pkg"; then
        echo "[OK] $pkg already stowed"
    else
        echo "[STOW] $pkg"
        stow -t ~ "$pkg"
    fi
done

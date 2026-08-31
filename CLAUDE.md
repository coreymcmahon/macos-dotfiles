# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository managed with GNU Stow. Each top-level directory represents a "package" of configuration files that can be symlinked to the home directory.

## Usage

```bash
# Install everything, stow dotfiles, and configure sensible defaults
./install.sh

# Or stow dotfiles manually (aerospace, alacritty, starship, tmux, zsh)
./bin/stow.sh

# Or stow individual packages
stow -t ~ alacritty

# Remove a symlinked package
stow -D -t ~ alacritty
```

## Structure

Each directory follows Stow conventions - the internal structure mirrors where files should land relative to `~`:

- `aerospace/` - AeroSpace tiling window manager config (`.config/aerospace/`)
- `alacritty/` - Alacritty terminal config (`.config/alacritty/`)
- `nvim/` - Neovim configuration (`.config/nvim/`)
- `starship/` - Starship prompt config (`.config/starship.toml`)
- `tmux/` - tmux config (`.config/tmux/`)
- `zsh/` - Zsh configuration (`.zshrc`, `.zshenv`)
- `bin/` - Helper scripts and `Brewfile` (not a Stow package)

## Notes

- Secrets go in `.zshrc.secrets` and `.zshenv.secrets` (not tracked)
- Language runtimes (PHP, Node, tree-sitter) are managed by Mise, not nvm/asdf - see `bin/setup-mise.sh`
- Global npm packages live in `bin/npm-globals.txt`, installed by `setup-mise.sh`
- Homebrew packages are declared in `bin/Brewfile`
- AeroSpace uses vim-style navigation (alt+hjkl) with workspaces 1-9 on main monitor and A-Z on secondary

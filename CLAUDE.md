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
- `nvim/` - Neovim configuration (`.config/nvim/`) - see the Neovim section below
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

## Neovim

Requires **Neovim 0.12+**. Plugins are managed by lazy.nvim.

Layout inside `nvim/.config/nvim/`:

- `lua/plugins/` - one file per plugin area, auto-imported by lazy.nvim
- `lsp/<server>.lua` - full server definitions for servers nvim-lspconfig doesn't ship
- `after/lsp/<server>.lua` - overrides merged on top of nvim-lspconfig's defaults
- `after/ftplugin/` - per-filetype settings

Conventions worth knowing before editing:

- **Treesitter targets the `main` branch**, which is a rewrite. The `master`-era
  API (`nvim-treesitter.configs`, `ensure_installed`/`highlight` tables) is frozen
  and will not work. Neovim 0.12 only auto-enables treesitter highlighting for
  Markdown, so `treesitter.lua` starts it explicitly via a `FileType` autocmd.
- **No Mason.** Language servers are installed by the dotfiles - npm ones via
  `bin/npm-globals.txt`, `laravel-lsp` via `composer global require laravel/lsp`,
  `lua-language-server` via the Brewfile. `bin/npm-globals.txt` is the source of
  truth for what `lua/plugins/lsp.lua` enables.
- **LSP uses the native 0.11+ API** (`vim.lsp.config` / `vim.lsp.enable`), not
  `require('lspconfig').<server>.setup()`.
- **Blade** needs no special plugins: the parser ships with nvim-treesitter and
  Neovim detects `*.blade.php` natively. Don't re-add `vim-blade` or `php.vim` -
  they fight treesitter.
- **Commenting is built in.** Neovim 0.12's `gc` resolves commentstrings through
  the treesitter injection tree, so `nvim-ts-context-commentstring` is not needed.
- Completion is blink.cmp, which is deliberately **not** lazy-loaded - it
  registers LSP capabilities from `plugin/`, which must run before servers attach.
- Formatting is conform.nvim (`pint` for PHP, `blade-formatter` for Blade,
  `prettierd`/`eslint_d` for JS/TS, `stylua` for Lua). `:FormatDisable` /
  `:FormatEnable` toggle format-on-save.
- Neovim 0.11+ already maps `grn`/`gra`/`grr`/`gri`/`grt`/`grx`. Never map a bare
  `gr` - it shadows the whole prefix and adds a `timeoutlen` stall to each.

### Neovim dependencies

Everything below is installed by `./install.sh`. Where each piece comes from:

| Dependency | Provided by | Needed for |
| --- | --- | --- |
| Neovim 0.12+ | `bin/Brewfile` | everything; `init.lua` refuses to load on older |
| `tree-sitter` CLI | `bin/npm-globals.txt` | nvim-treesitter `main` compiles parsers with it |
| C compiler, `make` | Xcode Command Line Tools | building parsers and telescope-fzf-native |
| `ripgrep`, `fd` | `bin/Brewfile` | Telescope grep and file pickers |
| `lua-language-server` | `bin/Brewfile` | `lua_ls` |
| `stylua` | `bin/Brewfile` | Lua formatting (reads `nvim/.config/nvim/stylua.toml`) |
| npm language servers | `bin/npm-globals.txt` | intelephense, vtsls, vue_ls, tailwindcss, jsonls, bashls, emmet |
| `prettierd`, `eslint_d`, `blade-formatter` | `bin/npm-globals.txt` | conform.nvim |
| `laravel-lsp` | `bin/setup-php-tools.sh` (composer global) | `laravel_lsp` |
| `pint` | per-project composer dev dependency | PHP formatting; conform finds `vendor/bin/pint` |
| Nerd Font | `bin/Brewfile` (JetBrains Mono) | icons in lualine, bufferline, neo-tree, blink |

`composer` itself is expected on PATH (Laravel Herd provides it here; `brew
install composer` also works). `setup-php-tools.sh` warns and skips rather than
failing if it is missing.

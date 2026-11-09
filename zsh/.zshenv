###
# Variables and settings accessible in non-interactive programs

###
# PATH
# Keep the first occurrence of each entry, so nested shells don't grow PATH.
typeset -U path PATH

# Homebrew on Apple Silicon. Intel's /usr/local/bin is on PATH by default.
path=(/opt/homebrew/bin(N/) /opt/homebrew/sbin(N/) $path)

export PATH="$HOME/.local/bin:$PATH"

# Composer global binaries (laravel-lsp, etc)
export PATH="$HOME/.composer/vendor/bin:$PATH"

# mysql-client is keg-only, so Homebrew doesn't link it into its bin dir
path=(/usr/local/opt/mysql-client/bin(N/) /opt/homebrew/opt/mysql-client/bin(N/) $path)

# mise-managed tools (node, npm, npx). The shims work in non-interactive
# shells and in processes spawned by them, where `mise activate` does not.
export PATH="$HOME/.local/share/mise/shims:$PATH"

###
# Secrets
# - Add export statements to .zshenv.secrets (e.g NPM_TOKEN)
if [ -f "$HOME/.zshenv.secrets" ]; then
    source "$HOME/.zshenv.secrets"
fi


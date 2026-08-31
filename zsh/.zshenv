###
# Variables and settings accessible in non-interactive programs

###
# PATH
export PATH="$HOME/.local/bin:$PATH"

###
# Secrets
# - Add export statements to .zshenv.secrets (e.g NPM_TOKEN)
if [ -f "$HOME/.zshenv.secrets" ]; then
    source "$HOME/.zshenv.secrets"
fi


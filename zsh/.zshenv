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

###
# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
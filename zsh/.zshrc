###
# Variables and settings used in interactive shells

###
# Secrets
# - Add sensitive aliases etc. to .zshrc.secrets
if [ -f "$HOME/.zshrc.secrets" ]; then
    source "$HOME/.zshrc.secrets"
fi

###
# Aliases
# Misc.
alias q=exit
alias ss="TERM=xterm-256color ssh" # use when connecting to a server with a different TERM (Ghostty, Kitty, etc)
alias killdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder" # flush local DNS cache
# Git
alias g=git
alias ga="git add"
alias gd="git diff"
alias gdc="git diff --cached"
alias gc="git commit"
alias gs="git status"
alias pull="git pull --no-rebase origin"
alias push="git push origin"
alias pullc="git pull --no-rebase origin $(git rev-parse --abbrev-ref HEAD)"
alias pushc="git push origin $(git rev-parse --abbrev-ref HEAD)"
alias co="git checkout"
# Laravel
alias s="./vendor/bin/sail"
alias art="php artisan"
# Neovim
alias vi="nvim"
alias vim="nvim"
# Node
alias ni="npm install"
alias nrd="npm run dev"
# Kitty
alias kittyssh="kitten ssh"

###
# GPG
GPG_TTY=$(tty)
export GPG_TTY

###
# VSCode
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

###
# Starship
eval "$(starship init zsh)"


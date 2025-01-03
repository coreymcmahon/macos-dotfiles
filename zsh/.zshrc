###
# Variables and settings used in interactive shells

###
# Aliases
alias g=git
alias ga="git add"
alias gd="git diff"
alias gc="git commit"
alias gs="git status"
alias s="./vendor/bin/sail"
alias vi="nvim"
alias vim="nvim"

###
# GPG
GPG_TTY=$(tty)
export GPG_TTY

###
# VSCode
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

###
# Herd
export HERD_PHP_83_INI_SCAN_DIR="/Users/coreymcmahon/Library/Application Support/Herd/config/php/83/"

# Herd injected PHP binary.
export PATH="/Users/coreymcmahon/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/coreymcmahon/Library/Application Support/Herd/config/php/84/"

###
# Starship
eval "$(starship init zsh)"

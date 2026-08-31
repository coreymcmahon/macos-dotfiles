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
# yolo: launch claude in a tmux top pane with a shell in the bottom pane
yolo() {
    local cmd="claude --dangerously-skip-permissions"
    (( $# )) && cmd+=" ${(q)@}"

    # Already inside tmux: add claude above the current shell rather than nesting
    if [ -n "$TMUX" ]; then
        tmux split-window -b -v -l 70% -c "$PWD" "$cmd"
        return
    fi

    local session="yolo-${${PWD:t}//[.:]/_}"
    if ! tmux has-session -t "=$session" 2>/dev/null; then
        tmux new-session -d -s "$session" -c "$PWD" "$cmd"
        tmux split-window -t "=$session:" -v -l 30% -c "$PWD"
        tmux select-pane -t "=$session:.{top}"
    fi
    tmux attach-session -t "=$session"
}
# Git
alias g=git
alias ga="git add"
alias gd="git diff"
alias gdc="git diff --cached"
alias gc="git commit"
alias gch="git checkout"
alias gs="git status"
alias gb="git branch -v"
alias gl="git log"
alias pull="git pull --no-rebase origin"
alias push="git push origin"
pullc() { git pull --no-rebase origin "$(git rev-parse --abbrev-ref HEAD)"; }
pushc() { git push origin "$(git rev-parse --abbrev-ref HEAD)"; }
alias ppc="pullc && pushc"
alias co="git checkout"
# Laravel
alias s="./vendor/bin/sail"
alias art="php artisan"
alias ci="composer install"
# lq: run the queue worker one job at a time, restarting so code changes are picked up
lq() {
    # Ctrl-C kills the worker, not the loop - trap it so one interrupt stops both.
    # zsh scopes traps set inside a function to that function.
    trap 'return' INT
    while true; do
        php artisan queue:work --once "$@"
        sleep 1
    done
}
# Neovim
alias vi="nvim"
alias vim="nvim"
# Node
alias ni="npm install"
alias nrd="npm run dev"
alias nird="npm install && npm run dev"
# Kitty
alias kittyssh="kitten ssh"

###
# Key bindings for word navigation
# Ctrl+Left/Right to move by word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
# Alt+Left/Right to move by word (some terminals use this)
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
# macOS Option+Left/Right
bindkey "^[b" backward-word
bindkey "^[f" forward-word

###
# GPG
GPG_TTY=$(tty)
export GPG_TTY

###
# VSCode
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

###
# Mise
eval "$(mise activate zsh)"

###
# Starship
eval "$(starship init zsh)"

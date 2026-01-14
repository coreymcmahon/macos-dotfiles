#!/bin/bash
set -euo pipefail

##
# Configure apps to start automatically on login

APPS=(
    "/Applications/1Password.app"
    "/Applications/Dropbox.app"
    "/Applications/AeroSpace.app"
)

for app in "${APPS[@]}"; do
    name=$(basename "$app" .app)

    if [[ ! -d "$app" ]]; then
        echo "[SKIP] $name not installed"
        continue
    fi

    # Check if already a login item
    if osascript -e "tell application \"System Events\" to get the name of every login item" 2>/dev/null | grep -q "$name"; then
        echo "[OK] $name already configured"
    else
        osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app\", hidden:true}"
        echo "[ADD] $name"
    fi
done

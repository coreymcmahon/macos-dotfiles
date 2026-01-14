#!/bin/bash
set -euo pipefail

##
# Configure Dock: clear and add preferred apps

APPS=(
    "AeroSpace"
    "Alacritty"
    "Brave Browser"
    "Obsidian"
    "Slack"
)

# Clear Dock
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Add apps
for app in "${APPS[@]}"; do
    app_path="/Applications/${app}.app"
    if [[ -d "$app_path" ]]; then
        defaults write com.apple.dock persistent-apps -array-add \
            "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        echo "[OK] $app"
    else
        echo "[SKIP] $app not found"
    fi
done

killall Dock

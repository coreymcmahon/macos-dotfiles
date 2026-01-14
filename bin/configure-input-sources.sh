#!/bin/bash
set -euo pipefail

##
# Configure keyboard input sources (US, British, Thai)

LAYOUTS="U.S.:0 British:2 Thai:-23"

has_layout() {
    defaults -currentHost read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null \
        | grep -q "KeyboardLayout ID.*= $1"
}

add_layout() {
    local name="$1" id="$2"
    for key in AppleEnabledInputSources AppleInputSourceHistory AppleSelectedInputSources; do
        defaults -currentHost write com.apple.HIToolbox "$key" -array-add \
            "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>$id</integer><key>KeyboardLayout Name</key><string>$name</string></dict>"
    done
}

for layout in $LAYOUTS; do
    name="${layout%:*}"
    id="${layout#*:}"
    if has_layout "$id"; then
        echo "[OK] $name already configured"
    else
        echo "[ADD] $name"
        add_layout "$name" "$id"
    fi
done

echo "Log out/in for changes to take effect."

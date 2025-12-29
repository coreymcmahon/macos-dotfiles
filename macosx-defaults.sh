#!/bin/sh

##
# Sensible defaults for Mac OS X

##
# Software Updates

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Automatically download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1


##
# Input Sources

# Enable Thai Keyboard Layout
LAYOUT_ID="-26624"
LAYOUT_NAME="Thai"
if defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null \
  | grep -Eq "\"KeyboardLayout ID\" = (\"$LAYOUT_ID\"|$LAYOUT_ID)"; then
    echo "$LAYOUT_NAME keyboard layout already enabled."
else
    echo "Adding $LAYOUT_NAME keyboard layout..."
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '{
        InputSourceKind = "Keyboard Layout";
        "KeyboardLayout ID" = '"$LAYOUT_ID"';
        "KeyboardLayout Name" = "'"$LAYOUT_NAME"'";
    }'
    echo "$LAYOUT_NAME keyboard layout added"
fi

# Show input method selector in tray
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.TextInputMenuAgent "NSStatusItem Visible Item-0" -bool true


##
# Text and typing

# Remove all annoying text replacements (eg. CP, TM, etc)
defaults delete -g NSUserDictionaryReplacementItems

# Disable annoying autocorrections/substitutions
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticEmojiSubstitutionEnabled -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast KeyRepeat rate
defaults write NSGlobalDomain KeyRepeat -int 1 
defaults write NSGlobalDomain InitialKeyRepeat -int 4

# Expand save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Full keyboard access in dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

##
# Scrolling & Scrollbars (Global)

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Use "natural" scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true


##
# Finder

# Show all files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show full POSIX path in Finder title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Always open everything in Finder's list view
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true


##
# Dock

# Dock icon size and magnification
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Remove the auto-hiding Dock delay and speed up the animation
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true


##
# Screen Saver & Security

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


##
# Screenshots

# Save screenshots to a dedicated folder
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Disable screenshot shadows
defaults write com.apple.screencapture disable-shadow -bool true


##
# Desktop Services

# Avoid creating .DS_Store files on network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Don't write .DS_Store on USB/removable volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


##
# Trackpad

# Enable tap to click (Trackpad), also for login menu
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking 1


##
# Hot corners

# Disable all hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0

defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0

defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

# Top-right hot corner: Lock Screen
defaults write com.apple.dock wvous-tr-corner -int 13
defaults write com.apple.dock wvous-tr-modifier -int 0


##
# Filesystem

# Show the ~/Library folder
chflags nohidden ~/Library


##
# Kill affected applications and services
for app in Safari Finder Dock Mail SystemUIServer TextInputMenuAgent; do killall "$app" >/dev/null 2>&1; done
killall cfprefsd

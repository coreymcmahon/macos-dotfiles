# Dotfiles

## Pre-Installation

### Option A: Quick start
Uses curl (pre-installed on macOS), no waiting for Xcode tools.
```bash
curl -sL https://github.com/coreymcmahon/macos-dotfiles/archive/refs/heads/main.tar.gz | tar xz
cd macos-dotfiles-main
```

### Option B: Clone with git
Requires Xcode Command Line Tools (opens dialog, takes a few minutes).
```bash
xcode-select --install
git clone https://github.com/coreymcmahon/macos-dotfiles.git
cd macos-dotfiles
```

## Installation
```bash
./install.sh [hostname]  # defaults to Coreys-MacBook-Pro
```

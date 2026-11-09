# Dotfiles

## Pre-Installation

Install the Xcode Command Line Tools (provides `git`, and the compiler Neovim uses to build parsers). This opens a dialog and returns straight away, so wait for the installer to finish before continuing:
```bash
xcode-select --install
```

Clone over HTTPS (SSH keys aren't set up yet):
```bash
git clone https://github.com/coreymcmahon/macos-dotfiles.git ~/Code/coreymcmahon/macos-dotfiles
cd ~/Code/coreymcmahon/macos-dotfiles
```

## Installation
```bash
./install.sh [hostname]  # defaults to Coreys-MacBook-Pro
```

Stay at the machine while it runs:

- The script pauses for Laravel Herd's setup wizard - finish it, then press Enter.
- Homebrew and the hostname step ask for your password.
- macOS asks to let your terminal control System Events - allow it, or the login items step fails and stops the script.

## Post-Installation

1. Restore `~/.zshrc.secrets`, `~/.zshenv.secrets` and `~/.npmrc` (not tracked).
2. Set up SSH and GPG keys - see [docs/ssh-and-gpg-keys.md](docs/ssh-and-gpg-keys.md). Commits fail until the GPG signing key is back, because `git/.gitconfig` turns on signing.
3. Switch this repo's remote to SSH:
   ```bash
   git remote set-url origin git@github.com:coreymcmahon/macos-dotfiles.git
   ```
4. Launch Brave once and quit it, then run `bin/setup-brave.sh`. `install.sh` skips this step until Brave has created its profile directory.
5. Run `git status` in this repo. Herd writes to `~/.zshrc`, which is a symlink to `zsh/.zshrc`, so any lines it added show up as changes. Move them into `~/.zshrc.secrets` rather than committing them.

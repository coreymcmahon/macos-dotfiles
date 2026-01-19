# SSH and GPG Keys for GitHub

## SSH Key Setup

Generate an Ed25519 key

```bash
ssh-keygen -t ed25519 -C "contact@coreymcmahon.com"
```

Start the agent and add your key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Add to `~/.ssh/config`:

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

Copy public key and add to GitHub (Settings → SSH and GPG keys):

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Test the connection:

```bash
ssh -T git@github.com
```

## GPG Signing Key Setup

Generate a GPG key (use RSA 4096-bit):

```bash
gpg --full-generate-key
```

List keys and copy the key ID (the long string after `sec rsa4096/`):

```bash
gpg --list-secret-keys --keyid-format=long
```

Export and add to GitHub (Settings → SSH and GPG keys):

```bash
gpg --armor --export YOUR_KEY_ID | pbcopy
```

Configure Git to use GPG signing:

```bash
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

If you get signing errors, add to your shell config:

```bash
export GPG_TTY=$(tty)
```

## Verify Setup

```bash
# Test SSH
ssh -T git@github.com

# Test GPG signing
echo "test" | gpg --clearsign
```

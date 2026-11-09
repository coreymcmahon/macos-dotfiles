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

`git/.gitconfig` sets `user.signingkey` and turns on commit and tag signing, and `.zshrc` exports `GPG_TTY`. That leaves one step: make sure the configured key is in your keyring. Import it if you have a backup, or generate a new one if you don't.

Check whether the key is already in your keyring:

```bash
gpg --list-secret-keys "$(git config --global user.signingkey)"
```

If that lists a key, skip to [Verify Setup](#verify-setup).

### Option A: Import the existing key

Do this if you have a backup of the key, or if the old machine is still available. Export the key there and store the file somewhere safe:

```bash
gpg --armor --export-secret-keys "$(git config --global user.signingkey)" > signing-key.asc
```

On the new machine, import it and delete the file:

```bash
gpg --import signing-key.asc
rm signing-key.asc
```

The public key is already on GitHub, so there's nothing else to do.

### Option B: Generate a new key

Do this if you have no copy of the existing key. Generate a key (use RSA 4096-bit):

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

Point Git at the new key. This writes through the `~/.gitconfig` symlink into `git/.gitconfig`, so commit the change:

```bash
git config --global user.signingkey YOUR_KEY_ID
```

## Verify Setup

```bash
# Test SSH
ssh -T git@github.com

# Test GPG signing
echo "test" | gpg --clearsign
```

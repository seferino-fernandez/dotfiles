## dotfiles

## Initial Setup

**Use 'chezmoi' to install and manage dotfiles:**

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply seferino-fernandez
```

### macOS
'macOS' uses [Homebrew](https://brew.sh/) to manage packages.

### Debian
'Debian' uses [Linuxbrew - Homebrew](https://brew.sh/) to manage packages.

### Fedora and Aurora
'Fedora' and 'Aurora' use [Linuxbrew - Homebrew](https://brew.sh/) to manage packages.

### Ubunto on WSL
'Ubunto on WSL' uses [Nix](https://nix.dev/) to manage packages.

## Useful Commands

**Allow user to `sudo` without password:**

```shell
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$USER-for-sudo-password
```

## Resources

### Nix
- https://nix.dev/ - Nix CLI documentation
- https://search.nixos.org/packages - Search for Nix packages
# dotfiles

This repository contains all my dotfiles managed by [chezmoi](https://github.com/twpayne/chezmoi).

## Initialization on a new machine

To initialize the dotfiles on a new machine, run the following commands:

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Checkout the dotfiles repository
chezmoi init <repo_url>

# Check for potential differences to already existing files
chezmoi diff

# If everything is fine, apply the changes from upstream
chezmoi apply
```

All of the above steps can be run in a single step as well:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <repo_url>
```

# Dotfiles (MacOS)

## Prerequisites

- Neovim
- Ghostty
- Starship

## Setup

- `brew install starship`
- `brew install stow`

## Stow Commands

Set up `Dotfiles` within the root directory.

- `stow -v vim zsh config` - Stows files to root directory
- `stow -v -D vim zsh config` - Deletes the stowed files
- `stow -v -R vim zsh config` - Reloads updated files

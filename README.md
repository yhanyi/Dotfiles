# Dotfiles (Ubuntu)

Clean, minimalist set of configuration files for my Nanode (Ubuntu) cluster.

## Tools

- vim/nvim
- tmux
- cmake
- gdb
- perf
- cargo

## Commands
```bash
# Package installation.
sudo apt update
sudo apt install build-essential
sudo apt install gdb
sudo apt install vim
sudo apt install perf
sudo apt install cmake
sudo apt install ripgrep
sudo apt install cargo

# Set up git.
# Set up nvim nightly build, install Linux version.

# Set timezone. 
sudo timedatectl set-timezone Asia/Singapore

# C++ Libraries
sudo apt install libboost-all-dev
```

## Symlinking
```bash
ln -s ~/Dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Dotfiles/.vimrc ~/.vimrc
ln -s ~/Dotfiles/.bashrc ~/.bashrc
ln -s ~/Dotfiles/starship.toml ~/.config/starship.toml
```

## tmux
```bash
tmux new-session -s <name>      # Create new session (workspace).
Ctrl+b c                        # Create new window (tab).
Ctrl+b %/"                      # Split panes vertically/horizontally.
```

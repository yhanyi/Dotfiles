# Dotfiles (Ubuntu)

Clean, minimalist set of configuration files for my Nanode (Ubuntu) cluster, mainly doing projects in C++23.

## Tools

- vim/nvim
- tmux
- cmake
- gdb
- perf

That's it, nothing else.

## Commands
```bash
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
```

## Symlinking
```bash
ln -s ~/Dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Dotfiles/.vimrc ~/.vimrc
ln -s ~/Dotfiles/.bashrc ~/.bashrc
ln -s ~/Dotfiles/starship.toml ~/.config/starship.toml
```

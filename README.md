# Dotfiles

## Ubuntu

```bash
sudo apt update
sudo apt install build-essentials
sudo apt install curl
sudo apt install git
sudo snap install ghostty --classic
sudo apt install clangd
sudo apt install gdb
sudo apt install cmake
sudo apt install python3-pip build-essential python3-dev
sudo apt install pyright
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt install neovim
sudo apt install tmux
curl -sS https://starship.rs/install.sh | sh

# Git
git config --global user.name "<name>"
git config --global user.email "<email>"
ssh-keygen -t ed25519 -C "<email>"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

## MacOS

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

## Notes

- Use [nightly nvim](https://github.com/neovim/neovim/releases).
- Use [Geist Mono](https://www.nerdfonts.com/font-downloads).
- On MacOS, set up UTM with Ubuntu for Linux development.

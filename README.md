# dotfiles

Managing my dotfiles a bit more seriously.

## Setup

Ensure you have Homebrew installed, and use `brew install stow` to download the symlink manager. Also run `brew install starship`.

Install tmux and catpuccin:

```bash
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.1 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```

Navigate to this folder, then run `stow . -t ~` to generate symbolic links to the files in this folder within your root directory. To verify all the files were successfully copied, run `ls -lah` in the root directory or `ls -lah <file>` to check for individual files.

The repository currently includes:

```bash
├── .config
│   ├── kitty
│   │   └── kitty.conf
│   └── nvim
│       ├── .ignore
│       ├── .stylua.toml
│       ├── init.lua
│       ├── lazy-lock.json
│       └── lua
│           ├── core
│           │   ├── bootstrap.lua
│           │   ├── default_config.lua
│           │   ├── init.lua
│           │   ├── mappings.lua
│           │   └── utils.lua
│           ├── custom
│           │   ├── chadrc.lua
│           │   ├── configs
│           │   │   ├── lspconfig.lua
│           │   │   └── null-ls.lua
│           │   ├── init.lua
│           │   ├── mappings.lua
│           │   └── plugins.lua
│           └── plugins
│               ├── configs
│               │   ├── cmp.lua
│               │   ├── lazy_nvim.lua
│               │   ├── lspconfig.lua
│               │   ├── mason.lua
│               │   ├── neocord.lua
│               │   ├── nvimtree.lua
│               │   ├── others.lua
│               │   ├── telescope.lua
│               │   └── treesitter.lua
│               └── init.lua
├── .tmux.conf
├── .vimrc
└── .zshrc
```

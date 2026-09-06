# Dotfiles

## MacOS

Eh.

## Arch

Eh.

## Windows

Install MSYS2.

```shell
pacman -S mingw-w64-ucrt-x86_64-gcc
pacman -S mingw-w64-ucrt-x86_64-clang
pacman -S mingw-w64-ucrt-x86_64-clang-tools-extra
pacman -S mingw-w64-ucrt-x86_64-rust
```

Check that the following are installed.

```shell
which gcc           # /ucrt64/bin/gcc
which clang         # /ucrt64/bin/clang
which clang-format  # /ucrt64/bin/clang-format
which clangd        # /ucrt64/bin/clangd
which cargo         # /ucrt64/bin/cargo
```

Go to Start -> Edit the system environment variables -> Environment Variables -> System variables -> Path.
Add `C:\msys64\ucrt64\bin`. Look for `C:\MinGW\bin`. Either remove it, or drag the ucrt64 path above it.

Verify by running `where.exe gcc` (`C:\msys64\ucrt64\bin\gcc.exe`) and `gcc --version` (`gcc.exe (Rev...) 16.x.x`).

Powershell

```shell
# Remove directory.
Remove-Item -Path "C:\path\to\folder" -Recurse -Force
# Symlink dotfiles.
New-Item -ItemType SymbolicLink -Path "C:\path\to\dst" -Target "C:\path\to\src"
```

## Neovim/Lua

Run these from inside Neovim.

```shell
# Check LSP health.
:checkhealth
# Identify OS.
:lua print(vim.uv.os_uname().sysname)
```

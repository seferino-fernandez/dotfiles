#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew"
    brew update
fi

brew install zsh \
    curl \
    git \
    luarocks \
    luajit \
    neovim \
    eza \
    bat \
    ripgrep \
    ast-grep \
    fd \
    zoxide \
    fzf \
    sheldon \
    starship \
    fnm \
    chezmoi \
    uv \
    tectonic \
    jj \
    1password-cli \
    lazygit \
    git-delta \
    difftastic \
    font-fira-code-nerd-font \
    font-jetbrains-mono-nerd-font

# atuin
if [[ $(command -v atuin) == "" ]]; then
    brew install atuin
fi

if [[ $(command -v cargo) == "" ]]; then
    echo "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Updating Rust"
    rustup update
fi

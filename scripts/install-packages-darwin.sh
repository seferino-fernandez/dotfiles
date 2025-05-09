#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew"
    brew update
fi

brew install --cask font-jetbrains-mono-nerd-font

brew install zsh \
    curl \
    git \
    neovim \
    eza \
    bat \
    ripgrep \
    fd \
    zoxide \
    fzf \
    sheldon \
    starship \
    fnm \
    chezmoi \
    uv

if [[ $(command -v cargo) == "" ]]; then
    echo "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Updating Rust"
    rustup update
fi

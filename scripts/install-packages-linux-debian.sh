#!/usr/bin/env bash

sudo apt-get install build-essential procps curl file git

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

sudo chsh -s "$(which zsh)"

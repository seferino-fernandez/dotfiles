#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
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
    chezmoi

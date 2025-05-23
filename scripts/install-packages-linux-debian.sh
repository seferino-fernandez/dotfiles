#!/usr/bin/env bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install build-essential procps curl file git

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

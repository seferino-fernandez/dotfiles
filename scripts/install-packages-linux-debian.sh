#!/usr/bin/env bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install build-essential procps curl file git

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >>/home/seferinofernandez/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/seferinofernandez/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "Updating Homebrew"
    brew update
fi

brew install zsh \
    curl \
    git \
    neovim \
    luajit \
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
    tectonic

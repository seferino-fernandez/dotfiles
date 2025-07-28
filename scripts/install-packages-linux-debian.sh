#!/usr/bin/env bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get -y install build-essential procps curl file git

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >>"/home/$USER/.bashrc"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"/home/$USER/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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
    lazygit

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

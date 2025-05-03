#!/usr/bin/env bash

sudo dnf install zsh

sudo chsh "$USER"

if [[ $(command -v cargo) == "" ]]; then
    echo "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Updating Rust"
    rustup update
fi

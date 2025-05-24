#!/usr/bin/env bash

# --- Helper Functions ---
# Function to print styled messages
_print_msg() {
    local color_code="$1"
    local message="$2"
    #โซ, these are ANSI escape codes. \033 is ESC. [0m resets.
    # e.g. \033[1;34m is bold blue
    echo -e "\033[${color_code}m${message}\033[0m"
}

msg() {
    _print_msg "1;34" "[INFO] $1"
}

msg_success() {
    _print_msg "1;32" "[SUCCESS] $1"
}

msg_error() {
    # Print to stderr
    _print_msg "1;31" "[ERROR] $1" >&2
}

# --- System Update (APT) ---
msg "Updating and upgrading base system packages with apt..."
if sudo apt update && sudo apt upgrade -y; then
    msg_success "Base system packages updated successfully."
else
    msg_error "Failed to update base system packages. Script will exit."
    exit 1
fi
echo

sudo apt install -y curl build-essential

# --- Nix Setup ---
msg "Setting up Nix environment..."

if command -v nix &> /dev/null; then
    msg_success "Nix is already installed and accessible in PATH."
else
    msg "Nix command not found. Attempting to install Nix..."
    # Install Nix non-interactively using the official multi-user installer (daemon mode).
    # --daemon: Perform a multi-user installation, which sets up the Nix daemon.
    # --no-confirm: Skip interactive confirmation prompts.
    # Note: The installer might attempt to modify shell profiles.
    # If you manage these with chezmoi and prefer manual setup, consider adding --no-modify-profile
    # and then ensuring your chezmoi-managed profiles source the Nix environment correctly.
    if curl -L https://nixos.org/nix/install | sh -s -- --daemon --no-confirm; then
        msg_success "Nix installed successfully."
        # Nix installer usually requires a new shell or sourcing its script for the current session.
    else
        msg_error "Nix installation failed. Script will exit."
        exit 1
    fi
fi

# Source Nix profile to make `nix` command and paths available for the rest of the script.
NIX_DAEMON_PROFILE_SCRIPT='/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' # For multi-user (daemon) installs
NIX_SINGLE_USER_PROFILE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh" # For single-user installs

FOUND_NIX_PROFILE_TO_SOURCE=false
if [ -f "$NIX_DAEMON_PROFILE_SCRIPT" ]; then
    # shellcheck source=/dev/null
    . "$NIX_DAEMON_PROFILE_SCRIPT"
    msg_success "Nix daemon environment sourced from $NIX_DAEMON_PROFILE_SCRIPT."
    FOUND_NIX_PROFILE_TO_SOURCE=true
elif [ -f "$NIX_SINGLE_USER_PROFILE_SCRIPT" ]; then # Fallback for potential single-user installations
    # shellcheck source=/dev/null
    . "$NIX_SINGLE_USER_PROFILE_SCRIPT"
    msg_success "Nix single-user environment sourced from $NIX_SINGLE_USER_PROFILE_SCRIPT."
    FOUND_NIX_PROFILE_TO_SOURCE=true
fi

if ! command -v nix &> /dev/null; then
    msg_error "Nix command is not available even after attempting to source profile scripts."
    msg "This might indicate an issue with the Nix installation or PATH configuration not taking effect in this session."
    msg "Please try opening a new shell session after the script finishes."
    exit 1 
elif ! $FOUND_NIX_PROFILE_TO_SOURCE && [ -f "$NIX_DAEMON_PROFILE_SCRIPT" ]; then
    # This case handles if Nix was already installed but somehow not sourced initially.
    # shellcheck source=/dev/null
    . "$NIX_DAEMON_PROFILE_SCRIPT"
    msg_success "Nix daemon environment (re-)sourced from $NIX_DAEMON_PROFILE_SCRIPT."
elif ! $FOUND_NIX_PROFILE_TO_SOURCE && [ -f "$NIX_SINGLE_USER_PROFILE_SCRIPT" ]; then
    # shellcheck source=/dev/null
    . "$NIX_SINGLE_USER_PROFILE_SCRIPT"
    msg_success "Nix single-user environment (re-)sourced from $NIX_SINGLE_USER_PROFILE_SCRIPT."
fi
echo

# Function to install or update a Nix package using a flake reference
install_or_update_nix_package() {
    local package_name_for_log="$1"
    local nix_flake_ref="$2"
    
    msg "Processing Nix package: $package_name_for_log (using $nix_flake_ref)..."
    
    if ! command -v nix &> /dev/null; then
        msg_error "Nix command became unavailable. Cannot install/update $package_name_for_log."
        exit 1 
    fi

    # --extra-experimental-features flakes: Enables the Flakes feature for this command.
    # --accept-flake-config: Auto-accepts flake configurations if prompted.
    if nix profile install \
        --extra-experimental-features flakes \
        --accept-flake-config \
        "$nix_flake_ref"; then
        msg_success "$package_name_for_log installed/updated successfully via Nix."
    else
        msg_error "Failed to install/update $package_name_for_log ($nix_flake_ref) via Nix. Script will exit."
        if [[ "$nix_flake_ref" == github:* ]]; then
            msg "Tip: For GitHub flakes, ensure the repository and flake path are correct."
        fi
        msg "Tip: Ensure your internet connection is stable and the Nix channels/flakes are accessible."
        exit 1
    fi
}

# --- Install/Update Packages with Nix ---
msg "Installing/Updating application packages using Nix profiles..."

# List of standard packages from nixpkgs
declare -A nix_packages=(
    ["zsh"]="nixpkgs#zsh"
    ["chezmoi"]="nixpkgs#chezmoi"
    ["ripgrep"]="nixpkgs#ripgrep"
    ["starship"]="nixpkgs#starship"
    ["neovim"]="nixpkgs#neovim"
    ["zoxide"]="nixpkgs#zoxide"
    ["fzf"]="nixpkgs#fzf"
    ["eza"]="nixpkgs#eza"
    ["bat"]="nixpkgs#bat"
    ["fd"]="nixpkgs#fd"
    ["sheldon"]="nixpkgs#sheldon"
    ["uv"]="nixpkgs#uv"
)

for pkg_name in "${!nix_packages[@]}"; do
    install_or_update_nix_package "$pkg_name" "${nix_packages[$pkg_name]}"
    echo
done

# --- Rust (via rustup) ---
echo
msg "Checking Rust installation (via rustup)..."
if command -v cargo &> /dev/null; then
    msg "Rust (cargo) is already installed. Attempting to update Rust..."
    if rustup update; then
        msg_success "Rust updated successfully."
    else
        msg_error "Failed to update Rust. It might be up-to-date or an error occurred. Continuing..."
    fi
else
    msg "Rust (cargo) not found. Installing Rust via rustup non-interactively..."
    # -y: Disable confirmation prompt for rustup.
    # --no-modify-path: Do not modify shell profiles (e.g., .bashrc, .profile).
    # PATH modifications for $HOME/.cargo/bin should be handled in your chezmoi-managed dotfiles.
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path; then
        msg_success "Rust installed successfully via rustup."
        msg "IMPORTANT: To use Rust, ensure '$HOME/.cargo/bin' is in your PATH by sourcing '$HOME/.cargo/env' in your shell's rc file."
    else
        msg_error "Failed to install Rust via rustup. Continuing..."
    fi
fi
echo

# --- Final Notes on Shell Configuration ---
msg "Regarding shell configuration (e.g., .zshrc):"
if [ -f "$HOME/.zshrc" ]; then
    msg "Your '$HOME/.zshrc' exists. Changes from Nix and Rust (like PATH modifications) should be effective in new Zsh sessions."
    msg "Ensure it sources '$HOME/.cargo/env' if you installed Rust and want it in your PATH."
    msg "Nix paths should be available if the Nix installer modified system profiles or if you source it manually."
else
    msg "Your '$HOME/.zshrc' was not found. If you expect Zsh to be configured, ensure your dotfiles (via chezmoi) apply it."
fi

echo
msg_success "chezmoi install-packages-linux-ubuntu.sh script finished."
echo "---"
echo "IMPORTANT NEXT STEPS:"
echo "1. Restart your shell (or open a new terminal tab/window) for all changes to take full effect."
echo "   This is crucial for PATH updates from Nix and Rust to be recognized, especially if Nix was just installed."
echo "2. If you've just installed Zsh and want to use it as your default shell, you may need to run: chsh -s \$(which zsh)"
echo "   (You might need to log out and log back in for the default shell change to apply everywhere)."
#!/usr/bin/env bash
#
# ---
# reload-macos-setup.sh
#
# Description:
#   Reloads all tools/daemons related to my macOS setup.
#     - Aerospace
#     - Aerospace Swipe
#     - Borders
#
# Requirements:
#
# Usage:
#
# Exit Codes:
#   0: Success
# ---

set -euo pipefail # Enable strict mode: exit on error, unset variable, pipe failure

# --- Configuration ---

# --- Logging Functions ---

# Function to print info messages to stderr and a log file.
log_info() {
  echo "INFO[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}


# --- Core Functions ---

main() {
  # --- Main Script ---
  log_info "------------------------------------------------------------------"
  log_info "Reloading macOS workspace..."
  
  # Chezmoi
  chezmoi apply --force

  # Aerospace
  aerospace reload-config

  # Aerospace Swipe
  launchctl stop com.acsandmann.swipe
  launchctl start com.acsandmann.swipe
  log_info "Reload complete"
  log_info "------------------------------------------------------------------"

  exit 0
}

main "$@"

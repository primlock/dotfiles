#!/usr/bin/env bash

# Setup Script for Dotfiles Dependencies
#
# Description:
#   This script installs all required dependencies for the dotfiles environment
#   It is intended only for Ubuntu and Debian-based systems
#
#   The script performs the following steps:
#     1. Verifies the system is Ubuntu/Debian (checks /etc/debian_version)
#     2. Defines a list of core dependencies
#     3. Checks if each dependency is already installed
#     4. Installs any missing packages using apt
#     5. Displays clear, color-coded status messages for each step
#
#   Re-running this script is safe; already installed packages will be skipped
#
# Usage:
#   1. Make the script executable:
#        chmod +x config_setup.sh
#
#   2. Run the script normally:
#        ./config_setup.sh
#
#   3. (Optional) Run in dry-run mode to preview what would be installed:
#        ./config_setup.sh --dry-run
#
#   4. (Optional) Run with sudo privileges upfront to avoid multiple password prompts:
#        sudo ./config_setup.sh#
#
# Notes:
#   - This script must be run on a Debian or Ubuntu system with an internet connection
#   - It uses `apt update` and `apt install` internally
#   - Root privileges are required for package installation
#   - The `--dry-run` flag will not install or modify anything; it only lists missing dependencies

# Exit immediately on errors or unset variables
set -euo pipefail

# Color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Perform a dry run of the install script to show what would be installed
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Helper functions
info()    { echo -e "${YELLOW}[INFO]${RESET} $*"; }
success() { echo -e "${GREEN}[OK]${RESET} $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; }

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install a package via apt
install_package() {
  local package=$1
  info "Installing ${package}..."
  sudo apt install -y "$package"
  success "${package} installed successfully"
}

# Main logic
main() {
  if $DRY_RUN; then
    info "Running in dry-run mode — no changes will be made"
  fi

  info "Updating package lists..."
  sudo apt update -y

  # List of required dependencies
  local dependencies=(
    git
    wget
    curl
    unzip
    clangd
    fzf
  )

  # Check that we're on a Debian-based system
  if [[ ! -f /etc/debian_version ]]; then
    error "This script only supports Ubuntu/Debian systems"
    exit 1
  fi

  info "Detected Ubuntu/Debian system"

  for dep in "${dependencies[@]}"; do
    if command_exists "$dep"; then
      success "${dep} is already installed"
    else
      if $DRY_RUN; then
        info "Would install: ${dep}"
      else
        install_package "$dep" 
      fi
    fi
  done

  info "All dependencies checked and installed as needed"
}

main "$@"

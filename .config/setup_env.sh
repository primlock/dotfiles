#!/usr/bin/env bash

# Setup script for environment dependencies
#
# Description:
#   This script installs all required dependencies for the Ubuntu and Debian based systems environment
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
#        chmod +x setup_config.sh
#
#   2. Run the script normally:
#        ./setup_config.sh
#
#   3. (Optional) Run in dry-run mode to preview what would be installed:
#        ./setup_config.sh --dry-run
#
#   4. (Optional) Run with sudo privileges upfront to avoid multiple password prompts:
#        sudo ./setup_config.sh
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

# Install a binary from a URL
install_binary() {
  local name=$1
  local url=$2

  info "Installing $name from $url..."

  tmp_dir=$(mktemp -d)
  archive="$tmp_dir/archive"

  # Download the file
  if command_exists wget; then
    wget -q --show-progress -O "$archive" "$url"
  elif command_exists curl; then
    curl -L -sS -o "$archive" "$url"
  else
    error "Neither wget nor curl is installed"
    return 1
  fi

  # Extract based on file type
  case "$url" in
    *.tar.gz|*.tgz)
      tar -xzf "$archive" -C "$tmp_dir"
      ;;
    *.zip)
      unzip -q "$archive" -d "$tmp_dir"
      ;;
    *)
      cp "$archive" "$tmp_dir/$name"
      ;;
  esac

  # Find the binary (first executable in tmp_dir)
  binary_path=$(find "$tmp_dir" -maxdepth 1 -type f -executable | head -n1)
  if [[ -z "$binary_path" ]]; then
    error "Could not find executable in archive"
    rm -rf "$tmp_dir"
    return 1
  fi

  sudo mv "$binary_path" /usr/local/bin/
  sudo chmod +x /usr/local/bin/"$name"
  rm -rf "$tmp_dir"

  success "$name installed successfully"
}

# Main logic
main() {
  if $DRY_RUN; then
    info "Running in dry-run mode — no changes will be made"
  else
    info "Updating package lists..."
    sudo apt update -y
  fi

  # List of required packages
  local dependencies=(
    # Package management
    ca-certificates
    gnupg
    # Developer tools
    git
    # Build tools
    build-essential
    make
    cmake
    cmake-format
    clangd
    ninja-build
    pkg-config
    gdb
    valgrind
    python3
    # Network tools
    wget
    curl
    # CLI utilities
    dos2unix
    unzip
    fzf
    tree
  )

  # Define binaries to install
  declare -A binaries=(
    ["stylua"]="https://github.com/JohnnyMorganz/StyLua/releases/download/v2.3.1/stylua-linux-x86_64.zip"
  )

  # Check that we're on a Debian-based system
  if [[ ! -f /etc/debian_version ]]; then
    error "This script only supports Ubuntu/Debian systems"
    exit 1
  fi

  info "Detected Ubuntu/Debian system"

  for dep in "${dependencies[@]}"; do
    if dpkg -s "$dep" >/dev/null 2>&1; then
      success "${dep} is already installed"
    else
      if $DRY_RUN; then
        info "Would install ${dep}"
      else
        install_package "$dep"
      fi
    fi
  done


  # Install binaries
  for name in "${!binaries[@]}"; do
    url=${binaries[$name]}
    if command_exists "$name"; then
        success "${name} is already installed"
    else
      if $DRY_RUN; then
        info "Would install $name from $url"
      else
        install_binary "$name" "$url"
      fi
    fi
  done

  if ! $DRY_RUN; then
    info "All dependencies checked and installed as needed"
  fi
}

main "$@"

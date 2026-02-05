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
#     4. Installs any missing dependencies with apt or by downloading, extracting and installing the archive
#        manually
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

# Required packages
packages=(
  # Package management
  ca-certificates
  gnupg
  # Developer tools
  git
  tmux
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
  tar
  fzf
  ripgrep
  tree
  shfmt
  xclip
)

# Required binaries from remote archives
#
# Each entry maps a binary name to a pipe-delimited string:
#   URL|path_in_archive|install_directory|type
#
# Fields:
#   - URL             : location of the archive (.zip or .tar.gz)
#   - path_in_archive : relative path to binary or root folder inside the archive
#   - install_directory : target directory for installation
#   - type            : install type, either "bin" (single binary) or "prefix" (full directory)
declare -A archives=(
  ["stylua"]="https://github.com/JohnnyMorganz/StyLua/releases/download/v2.3.1/stylua-linux-x86_64.zip|stylua|/usr/local/bin|bin"
  ["nvim"]="https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz|nvim-linux-x86_64|/opt/nvim|prefix"
)

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Installs a Debian/Ubuntu package via apt
#
# Parameters:
#   $1 - package : name of the package to install
install_package() {
  local package=$1
  info "Installing ${package}..."
  sudo apt install -y "$package"
  success "${package} installed successfully"
}

# Downloads and installs a tool from a remote archive (.zip or .tar.gz)
# Supports two types:
#   - bin: single executable copied to the target directory
#   - prefix: full directory moved to the install path, with optional symlink to /usr/local/bin
#
# Parameters:
#   $1 - name       : tool/command name
#   $2 - spec       : pipe-delimited string: URL|path_in_archive|install_directory|type
#                     e.g., "https://.../tool.zip|tool|/usr/local/bin|bin"
#                           "https://.../nvim.tar.gz|nvim-linux-x86_64|/opt/nvim|prefix"
install_archive() {
  local name=$1
  local spec=$2

  IFS='|' read -r url path install_dir type <<< "$spec"

  # Create the sub-directory if it does not already exist
  if [ ! -d "$install_dir" ]; then
    mkdir -p $install_dir
    success "Created install directory $install_dir"
  fi

  info "Installing $name from $url"

  tmp_dir=$(mktemp -d)
  archive="$tmp_dir/archive"

  # Download
  if command_exists wget; then
    wget -q --show-progress -O "$archive" "$url"
  elif command_exists curl; then
    curl -L -sS -o "$archive" "$url"
  else
    error "Neither wget or curl is installed"
    rm -rf "$tmp_dir"
    return 1
  fi

  # Extract
  case "$url" in
    *.tar.gz|*.tgz)
      tar -xzf "$archive" -C "$tmp_dir"
      ;;
    *.zip)
      unzip -q "$archive" -d "$tmp_dir"
      ;;
    *)
      error "Unsupported archive format: $url"
      rm -rf "$tmp_dir"
      return 1
      ;;
  esac

  case "$type" in
    bin)
      local src="$tmp_dir/$path"
      [[ -f "$src" ]] || {
        error "Binary not found: $path"
        rm -rf "$tmp_dir"
        return 1
      }

      sudo install -m 0755 "$src" "$install_dir/$name"
      ;;

    prefix)
      local src="$tmp_dir/$path"
      [[ -d "$src" ]] || {
        error "Prefix directory not found: $path"
        rm -rf "$tmp_dir"
        return 1
      }

      # Replace existing install
      sudo rm -rf "$install_dir"
      sudo mv "$src" "$install_dir"

      # Create symlink
      sudo ln -sf "$install_dir/bin/$name" "/usr/local/bin/$name"
      ;;

    *)
      error "Unknown install type: $type"
      rm -rf "$tmp_dir"
      return 1
      ;;
  esac

  rm -rf "$tmp_dir"
  success "$name installed successfully"
}

main() {
  if $DRY_RUN; then
    info "Running in dry-run mode — no changes will be made"
  else
    info "Updating package lists..."
    sudo apt update -y
  fi

  # Check that we're on a Debian-based system
  if [[ ! -f /etc/debian_version ]]; then
    error "This script only supports Ubuntu/Debian systems"
    exit 1
  fi

  info "Detected Ubuntu/Debian system"

  # Install our required packages
  for package in "${packages[@]}"; do
    if dpkg -s "$package" >/dev/null 2>&1; then
      success "${package} is already installed"
    else
      if $DRY_RUN; then
        info "Would install ${package}"
      else
        install_package "$package"
      fi
    fi
  done

  # Install our required binaries
  for name in "${!archives[@]}"; do
    if command_exists "$name"; then
      success "$name is already installed"
    else
      if $DRY_RUN; then
        info "Would install $name"
      else
        install_archive "$name" "${archives[$name]}"
      fi
    fi
  done

  if ! $DRY_RUN; then
    success "All environment dependencies are installed"
  fi
}

main "$@"

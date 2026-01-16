#!/usr/bin/env bash

# Setup script for Docker-CE
#
# Description:
#   This script installs Docker Community Edition (Docker CE) and related tooling on Ubuntu and debian-based
#   systems.
#
#   It is intended to be run after the base dotfiles setup script, which installs common system dependencies
#   such as curl, gnupg, and sudo.
#
#   The script performs the following steps:
#     1. Verifies the system is Ubuntu/Debian (checks /etc/debian_version)
#     2. Validates that required system dependencies are present and functional
#        (apt, curl, gpg, sudo)
#     3. Adds Docker’s official GPG key to the APT keyrings directory
#     4. Configures Docker’s official APT repository using the system codename
#     5. Updates package lists to include the Docker repository
#     6. Installs Docker CE, Docker CLI, containerd, and Docker plugins
#     7. Enables and starts the Docker systemd service
#
#   Re-running this script is safe; already installed components will be skipped.
#
# Usage:
#   1. Make the script executable:
#        chmod +x setup_docker.sh
#
#   2. Run the script normally:
#        ./setup_docker.sh
#
#   3. (Optional) Run in dry-run mode to preview what would be installed:
#        ./setup_docker.sh --dry-run
#
#   4. (Optional) Run with sudo privileges upfront to avoid multiple password prompts:
#        sudo ./setup_docker.sh
#
# Notes:
#   - This script must be run on a Debian or Ubuntu system with an internet connection
#   - It assumes required base dependencies are installed by a prior setup script
#   - The script will exit early with helpful errors if dependencies are missing
#   - Root privileges are required for repository configuration and package installation
#   - The `--dry-run` flag does not modify the system; it only reports intended actions

# Exit immediately on errors or unset variables
set -euo pipefail

# Color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Dry-run mode
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

# Main logic
main() {
  if $DRY_RUN; then
    info "Running in dry-run mode — no changes will be made"
  fi

  # Check that we're on a Debian-based system
  if [[ ! -f /etc/debian_version ]]; then
    error "This script only supports Ubuntu/Debian systems"
    exit 1
  fi

  info "Detected Ubuntu/Debian system"

  # Check for dependencies
  info "Checking required dependencies..."

  local required_commands=(
    apt
    curl
    gpg
    sudo
  )

  local missing=()

  for cmd in "${required_commands[@]}"; do
    if ! command_exists "$cmd"; then
      missing+=("$cmd")
    fi
  done

  if [[ "${#missing[@]}" -ne 0 ]]; then
    error "Missing required dependencies: ${missing[*]}"
    error "Please run the base setup script before installing Docker"
    exit 1
  fi

  success "All required dependencies are present"

  # Validate GPG functionality
  info "Validating GPG functionality..."
  if ! gpg --version >/dev/null 2>&1; then
    error "gpg is installed but not functioning correctly"
    error "Please reinstall gnupg using the base setup script"
    exit 1
  fi
  success "GPG is functional"

  # Check sudo usability (non-fatal)
  if ! sudo -n true 2>/dev/null; then
    info "Sudo password may be required during installation"
  fi

  # Docker installation
  KEYRING_DIR="/etc/apt/keyrings"
  DOCKER_KEYRING="${KEYRING_DIR}/docker.asc"
  DOCKER_SOURCES="/etc/apt/sources.list.d/docker.sources"

  info "Updating package lists..."
  if ! $DRY_RUN; then
    sudo apt update -y
  fi

  # Create keyring directory
  if [[ ! -d "$KEYRING_DIR" ]]; then
    if $DRY_RUN; then
      info "Would create APT keyring directory at ${KEYRING_DIR}"
    else
      info "Creating APT keyring directory..."
      sudo install -m 0755 -d "$KEYRING_DIR"
      success "APT keyring directory created"
    fi
  else
    success "APT keyring directory already exists"
  fi

  # Download Docker GPG key
  if [[ ! -f "$DOCKER_KEYRING" ]]; then
    if $DRY_RUN; then
      info "Would download Docker GPG key"
    else
      info "Downloading Docker GPG key..."
      sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o "$DOCKER_KEYRING"
      sudo chmod a+r "$DOCKER_KEYRING"
      success "Docker GPG key installed"
    fi
  else
    success "Docker GPG key already exists"
  fi

  # Determine Debian codename
  CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

  # Add Docker repository
  if [[ ! -f "$DOCKER_SOURCES" ]]; then
    if $DRY_RUN; then
      info "Would add Docker APT repository for suite '${CODENAME}'"
    else
      info "Adding Docker APT repository..."
      sudo tee "$DOCKER_SOURCES" > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: ${CODENAME}
Components: stable
Signed-By: ${DOCKER_KEYRING}
EOF
      success "Docker APT repository added"
    fi
  else
    success "Docker APT repository already exists"
  fi

  # Update package lists again
  info "Updating package lists with Docker repository..."
  if ! $DRY_RUN; then
    sudo apt update -y
  fi

  # Docker packages
  local docker_packages=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
  )

  # Install Docker packages
  for pkg in "${docker_packages[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      success "${pkg} is already installed"
    else
      if $DRY_RUN; then
        info "Would install ${pkg}"
      else
        info "Installing ${pkg}..."
        sudo apt install -y "$pkg"
        success "${pkg} installed successfully"
      fi
    fi
  done

  # Enable Docker service
  if command_exists systemctl; then
    if $DRY_RUN; then
      info "Would enable and start Docker service"
    else
      info "Enabling Docker service..."
      sudo systemctl enable docker
      sudo systemctl start docker
      success "Docker service enabled and running"
    fi
  fi

  if ! $DRY_RUN; then
    info "Docker CE installation complete"
  fi
}

main "$@"

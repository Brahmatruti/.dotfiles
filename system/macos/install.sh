#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_macos.sh"


#==================================
# Print Section Title
#==================================
print_section "Running MacOS Dotfiles Setup"


#==================================
# Development Machine Detection
#==================================
print_title "Development Machine Setup"

read -p "Is this a development machine? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_title "Setting up development environment..."
    export IS_DEVELOPMENT_MACHINE=true

    # Install additional development packages
    print_title "Installing additional development packages"

    # Ansible & Terraform
    brew install ansible ansible-lint terraform opentofu

    # Docker
    brew install docker

    # Python
    brew install python@3.13

    # Additional development tools
    brew install jq yq yamllint helm k3sup kubectx kubernetes-cli
    brew install nmap iperf3 telnet wakeonlan vhs gh glab
    brew install influxdb-cli httpie hugo yadm direnv zoxide
    brew install duf dust bottom cmatrix teleport packer

    # Java
    brew install openjdk

    # Additional casks for development
    brew install --cask 1password-cli raycast warp

    print_success "Development environment setup completed"
else
    export IS_DEVELOPMENT_MACHINE=false
    print_title "Skipping development packages installation"
fi


#==================================
# Setup Scripts
#==================================

# setup symlinks
. "$HOME/.dotfiles/system/symlink.sh"

# setup packages
. "$HOME/.dotfiles/system/macos/setup_packages.sh"

# setup defaults
. "$HOME/.dotfiles/system/macos/setup_defaults.sh"

# setup shell
. "$HOME/.dotfiles/system/macos/setup_shell.sh"

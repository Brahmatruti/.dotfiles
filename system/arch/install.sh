#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_arch.sh"


#==================================
# Print Section Title
#==================================
print_section "Running Arch Dotfiles Setup"


#==================================
# Development Machine Detection
#==================================
print_title "Development Machine Setup"

read -p "Is this a development machine? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Setting up development environment..."
    export IS_DEVELOPMENT_MACHINE=true

    # Install additional development packages
    print_title "Installing additional development packages"
    sudo pacman -Syu --noconfirm

    # Install development tools
    sudo pacman -S --noconfirm \
        python python-pip python-virtualenv \
        jdk17-openjdk \
        docker docker-compose \
        ansible \
        base-devel openssl cmake \
        jq curl wget git

    # Setup Python development environment
    print_title "Setting up Python development environment"
    python -m pip install --user --upgrade pip
    python -m pip install --user virtualenv virtualenvwrapper

    # Setup Node.js development environment
    if ! command -v nvm &> /dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
        npm install -g yarn pnpm eslint prettier typescript
    fi

    # Install Terraform via AUR
    yay -S --noconfirm terraform

    print_success "Development environment setup completed"
else
    export IS_DEVELOPMENT_MACHINE=false
    print_info "Skipping development packages installation"
fi


#==================================
# Setup Scripts
#==================================

# setup symlinks
. "$HOME/.dotfiles/system/symlink.sh"

# setup packages
. "$HOME/.dotfiles/system/arch/setup_packages.sh"

# setup fonts
. "$HOME/.dotfiles/system/arch/setup_fonts.sh"

# setup defaults
. "$HOME/.dotfiles/system/arch/setup_defaults.sh"

# setup shell
. "$HOME/.dotfiles/system/arch/setup_shell.sh"

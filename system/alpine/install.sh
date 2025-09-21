#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_alpine.sh"


#==================================
# Print Section Title
#==================================
print_section "Running Alpine Dotfiles Setup"


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
    sudo apk update && sudo apk upgrade

    # Install development tools
    sudo apk add \
        python3 python3-dev py3-pip py3-virtualenv \
        openjdk17 \
        docker docker-compose \
        ansible \
        build-base openssl-dev cmake \
        jq curl wget git

    # Setup Python development environment
    print_title "Setting up Python development environment"
    python3 -m pip install --user --upgrade pip
    python3 -m pip install --user virtualenv virtualenvwrapper

    # Setup Node.js development environment
    if ! command -v nvm &> /dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
        npm install -g yarn pnpm eslint prettier typescript
    fi

    # Setup Docker group
    sudo addgroup $USER docker

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
. "$HOME/.dotfiles/system/alpine/setup_packages.sh"

# setup shell
. "$HOME/.dotfiles/system/alpine/setup_shell.sh"

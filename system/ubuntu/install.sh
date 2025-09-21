#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_ubuntu.sh"


#==================================
# Print Section Title
#==================================
print_section "Running Ubuntu Dotfiles Setup"


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
    sudo apt-get update
    sudo apt-get install -y \
        python3-dev python3-pip python3-venv \
        openjdk-17-jdk-headless \
        nodejs npm yarn \
        docker.io docker-compose \
        ansible terraform \
        build-essential libssl-dev \
        jq curl wget git-all

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
. "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"

# setup NFS (optional)
read -p "Do you want to setup NFS mounts? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    . "$HOME/.dotfiles/system/ubuntu/setup_nfs.sh"
fi

# setup fonts
. "$HOME/.dotfiles/system/ubuntu/setup_fonts.sh"

# setup defaults
. "$HOME/.dotfiles/system/ubuntu/setup_defaults.sh"

# setup shell
. "$HOME/.dotfiles/system/ubuntu/setup_shell.sh"

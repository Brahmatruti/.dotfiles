#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_ubuntu.sh"

# Source logging utilities and make functions available
. "$HOME/.dotfiles/scripts/utils/utils_logging.sh"
. "$HOME/.dotfiles/scripts/utils/utils_installation.sh"

# Export logging functions to make them available in this script
export -f log_success log_failure log_skipped log_warning log_info track_installation_attempt track_installation_result print_installation_summary


#==================================
# Print Section Title
#==================================
print_section "Installing Packages"


#==================================
# Add keys to apt
#==================================
print_title "Adding Keys"

apt_install "gpg" "gpg"
sudo mkdir -p /etc/apt/keyrings

# Eza
install_gpg_key "https://raw.githubusercontent.com/eza-community/eza/main/deb.asc" "Eza" "/etc/apt/keyrings/gierens.gpg"
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list &> /dev/null
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list


# Charm
install_gpg_key "https://repo.charm.sh/apt/gpg.key" "Charm" "/etc/apt/keyrings/charm.gpg"
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list &> /dev/null

#==================================
# Add repositories to apt
#==================================
print_title "Adding Repositories"
apt_add_repo "Universe" "universe"
apt_add_repo "Multiverse" "multiverse"
apt_add_repo "Fish" "ppa:fish-shell/release-3"


#==================================
# Update APT packages
#==================================
print_title "Update & Upgrade APT"
apt_update
apt_upgrade


#==================================
# Install APT packages
#==================================
print_title "Install APT Packages"


apt_install "curl" "curl"
apt_install "wget" "wget"
apt_install "pyhton3" "python3"
apt_install "git" "git"
apt_install "git-all" "git-all"
apt_install "git-lfs" "git-lfs"
apt_install "cargo" "cargo"

apt_install "tmux" "tmux"
apt_install "less" "less"
apt_install "eza" "eza"
apt_install "bat" "bat"
apt_install "tree" "tree"
apt_install "tre-command" "tre-command"
apt_install "fasd" "fasd"
apt_install "fd-find" "fd-find"
apt_install "fzf" "fzf"
apt_install "delta" "delta"
apt_install "ripgrep" "ripgrep"

apt_install "gum" "gum"
apt_install "htop" "htop"
apt_install "httpie" "httpie"
apt_install "prettyping" "prettyping"

apt_install "tldr" "tldr"
apt_install "neofetch" "neofetch"

apt_install "midnight-commander" "mc"
apt_install "node" "nodejs"
apt_install "yarn" "yarn"
apt_install "gcc" "gcc"
apt_install "micro" "micro"
apt_install "neovim" "neovim"
apt_install "ffmpeg" "ffmpeg"


#==================================
# Install Cargo packages
#==================================
# print_title "Install Cargo Packages"

# cargo_install "exa" "exa"


#==================================
# Install From Source
#==================================
print_title "Install Packages From Source"

# Tmux Plugin Manager (TPM)
execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"

# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
curl -Lo lazygit.tar.gz --silent --output /dev/null "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
rm -rf lazygit.tar.gz
print_success "lazygit"


#==================================
# Error Handling Functions
#==================================
apt_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        if execute "sudo apt-get install -y $package" "$description"; then
            return 0
        else
            retry_count=$((retry_count + 1))
            print_warning "Attempt $retry_count failed for $description"

            if [ $retry_count -lt $max_retries ]; then
                print_title "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    print_error "Failed to install $description after $max_retries attempts"
    return 1
}

handle_package_error() {
    local description="$1"
    local package="$2"

    print_warning "Package $description ($package) failed to install"
    print_question "Would you like to continue with other packages? (Y/n)"

    # Auto-continue with 3-second timeout, default "yes"
    read -t 3 -r choice
    if [ $? -gt 128 ]; then
        print_title "No response received within 3 seconds, continuing automatically..."
        choice="y"
    fi

    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        print_error "Installation cannot continue. Exiting."
        exit 1
    fi
}

#==================================
# Enhanced Package Installation
#==================================
apt_install() {
    local description="$1"
    local package="$2"

    if ! dpkg -l "$package" 2>/dev/null | grep -q "^ii"; then
        print_title "Installing $description..."
        if apt_install_with_retry "$description" "$package"; then
            print_success "$description installed successfully"
        else
            print_error "Failed to install $description"
            handle_package_error "$description" "$package"
        fi
    else
        print_success "$description is already installed"
    fi
}

#==================================
# Installation Summary
#==================================
print_installation_summary

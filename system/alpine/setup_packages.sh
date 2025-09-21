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
print_section "Installing Packages"


#==================================
# Update APT packages
#==================================
print_title "Update Packages"
apk_update

#==================================
# Install apk packages
#==================================
print_title "Install apk Packages"

apk_install "git" "git"
apk_install "curl" "curl"
apk_install "wget" "wget"
apk_install "pyhton3" "python3"
apk_install "jq" "jq"

apk_install "tmux" "tmux"
apk_install "less" "less"
apk_install "exa" "exa"
apk_install "bat" "bat"
apk_install "fasd" "fasd"
apk_install "fzf" "fzf"
apk_install "ripgrep" "ripgrep"

apk_install "htop" "htop"
apk_install "httpie" "httpie"
apk_install "prettyping" "prettyping"

apk_install "tldr" "tldr"
apk_install "neofetch" "neofetch"

apk_install "neovim" "neovim"

#==================================
# Install Cloud Storage Clients
#==================================
print_title "Install Cloud Storage Clients"

# MEGASync (using community repository)
echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk_update
apk_install "MEGASync" "megasync"

# Google Drive (using rclone for mounting)
apk_install "rclone" "rclone"

# pCloud Drive (not available in Alpine repos)
print_title "pCloud Drive: Not available in Alpine repositories"

# Synology Drive Client (not available in Alpine repos)
print_title "Synology Drive Client: Not available in Alpine repositories"

# QNAP Qsync (usually accessed via web interface or NFS/SMB mounts)
print_title "QNAP Qsync: Access via web interface or NFS/SMB mounts (no native Linux client)"

#==================================
# Install From Source
#==================================
print_title "Install Packages From Source"

# Tmux Plugin Manager (TPM)
rm -rf ~/.tmux/plugins/tpm
execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"


# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
curl -Lo lazygit.tar.gz --silent --output /dev/null "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
rm -rf lazygit.tar.gz
print_success "lazygit"

#==================================
# Install Development Tools (from Ubuntu equivalent)
#==================================
print_title "Install Development Tools"

# Docker
apk_install "Docker" "docker"
apk_install "Docker Compose" "docker-compose"
execute "sudo addgroup $USER docker" "Add User to Docker Group"

# Ansible & Terraform
apk_install "Ansible" "ansible"
execute "wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg" "HashiCorp GPG Key"
execute 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list' "HashiCorp Repository"
apk_update
apk_install "Terraform" "terraform"

# NVM, Node.js, npm, JS tools
execute "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash" "Install NVM"
execute 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts && nvm alias default "lts/*" && nvm use default' "Install Node.js LTS"
execute 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g npm yarn pnpm eslint prettier' "Install NPM Tools"

# OpenJDK
apk_install "OpenJDK 17" "openjdk17"

# Python development tools
apk_install "Python3 venv" "py3-virtualenv"
apk_install "Python3 pip" "py3-pip"

# Additional development packages
apk_install "Build tools" "build-base"
apk_install "SSL dev" "openssl-dev"
apk_install "jq" "jq"
apk_install "unzip" "unzip"
apk_install "make" "make"
apk_install "cmake" "cmake"
apk_install "gcc" "gcc"
apk_install "g++" "g++"

# NFS (Linux specific)
apk_install "NFS common" "nfs-utils"
apk_install "Autofs" "autofs"

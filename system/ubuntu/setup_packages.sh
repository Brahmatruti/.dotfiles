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
print_section "Installing Packages"


#==================================
# Add keys to apt
#==================================
print_title "Adding Keys"

apt_install "gpg" "gpg"
sudo mkdir -p /etc/apt/keyrings

# Eza
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg &> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list &> /dev/null
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

# Mono
sudo mkdir -p /etc/apt/keyrings
execute "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" "Mono (Add Key)"

# Charm
curl -fsSL --silent https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg &> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list &> /dev/null

#==================================
# Add repositories to apt
#==================================
print_title "Adding Repositories"

apt_add_repo "Universe" "universe"
apt_add_repo "Multiverse" "multiverse"
apt_add_repo "Fish" "ppa:fish-shell/release-3"
apt_add_repo "OBS Studio" "ppa:obsproject/obs-studio"
apt_add_repo "Alacritty" "ppa:aslatter/ppa"


#==================================
# Add sources to APT
#==================================
# print_title "Adding Sources"


#==================================
# Update APT packages
#==================================
print_title "Update & Upgrade APT"

apt_update
apt_upgrade


#==================================
# Install package managers
#==================================
print_title "Install Package Managers"

apt_install "nala" "nala"
apt_install "flatpak" "flatpak"
apt_install "flatpak gnome plugin" "gnome-software-plugin-flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1


#==================================
# Install APT packages
#==================================
print_title "Install APT Packages"

apt_install "Build Essential" "build-essential"
apt_install "Gnome Shell Extensions" "gnome-shell-extensions"
apt_install "Gnome Shell Extension Manager" "gnome-shell-extension-manager"
apt_install "Gnome Tweaks" "gnome-tweaks"

apt_install "heif-gdk-pixbuf" "heif-gdk-pixbuf"
apt_install "heif-thumbnailer" "heif-thumbnailer"

apt_install "gnupg" "gnupg"
apt_install "ca-certificates" "ca-certificates"
apt_install "dirmngr" "dirmngr"
apt_install "curl" "curl"
apt_install "wget" "wget"
apt_install "pyhton3" "python3"
apt_install "git" "git"
apt_install "git-all" "git-all"
apt_install "git-lfs" "git-lfs"
apt_install "apt-transport-https" "apt-transport-https"
apt_install "software-properties-common" "software-properties-common"
apt_install "libgconf-2-4" "libgconf-2-4"
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
apt_install "ripgrep" "ripgrep"

apt_install "gum" "gum"
apt_install "htop" "htop"
apt_install "httpie" "httpie"
apt_install "prettyping" "prettyping"
apt_install "mtr" "mtr"

apt_install "tldr" "tldr"
apt_install "neofetch" "neofetch"

apt_install "ranger" "ranger"
apt_install "midnight-commander" "mc"
apt_install "node" "nodejs"
apt_install "yarn" "yarn"
apt_install "gcc" "gcc"
apt_install "micro" "micro"
apt_install "neovim" "neovim"
apt_install "ffmpeg" "ffmpeg"

apt_install "nudoku" "nudoku"

apt_install "Alacritty" "alacritty"
apt_install "Caffeine" "caffeine"
apt_install "Notion" "notion"
apt_install "OBS Studio" "obs-studio"

#==================================
# Install Cloud Storage Clients
#==================================
print_title "Install Cloud Storage Clients"

# pCloud Drive
wget -qO - https://repo.pcloud.com/pcloud.gpg | sudo apt-key add -
echo "deb https://repo.pcloud.com/apt/debian/ stable main" | sudo tee /etc/apt/sources.list.d/pcloud.list
apt_update
apt_install "pCloud Drive" "pcloud"

# MEGASync
wget -qO - https://mega.nz/linux/repo/xUbuntu_22.04/Release.key | sudo apt-key add -
echo "deb https://mega.nz/linux/repo/xUbuntu_22.04/ ./" | sudo tee /etc/apt/sources.list.d/megasync.list
apt_update
apt_install "MEGASync" "megasync"

# Synology Drive Client
wget -qO - https://raw.githubusercontent.com/synology/SynologyDriveClient/master/synology-drive.gpg | sudo apt-key add -
echo "deb https://packages.synology.com/drive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/synology-drive.list
apt_update
apt_install "Synology Drive Client" "synology-drive"

# Google Drive (using rclone for mounting)
apt_install "rclone" "rclone"

# QNAP Qsync (usually accessed via web interface or NFS/SMB mounts)
print_info "QNAP Qsync: Access via web interface or NFS/SMB mounts (no native Linux client)"

#==================================
# Install Development Tools
#==================================
print_title "Install Development Tools"

# Docker + Compose
execute "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg" "Docker GPG Key"
execute 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null' "Docker Repository"
apt_update
apt_install "Docker" "docker-ce docker-ce-cli containerd.io docker-compose-plugin"
execute "sudo usermod -aG docker $USER" "Add User to Docker Group"

# Ansible & Terraform
apt_install "Ansible" "ansible"
execute "wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg" "HashiCorp GPG Key"
execute 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list' "HashiCorp Repository"
apt_update
apt_install "Terraform" "terraform"

# NVM, Node.js, npm, JS tools
execute "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash" "Install NVM"
execute 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts && nvm alias default "lts/*" && nvm use default' "Install Node.js LTS"
execute 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g npm yarn pnpm eslint prettier' "Install NPM Tools"

# OpenJDK
apt_install "OpenJDK 17" "openjdk-17-jdk"

# Python development tools
apt_install "Python3 venv" "python3-venv"
apt_install "Python3 pip" "python3-pip"

# Additional development packages
apt_install "Build tools" "build-essential"
apt_install "SSL dev" "libssl-dev"
apt_install "jq" "jq"
apt_install "unzip" "unzip"
apt_install "make" "make"
apt_install "gcc" "gcc"
apt_install "g++" "g++"

# NFS and autofs
apt_install "NFS common" "nfs-common"
apt_install "Autofs" "autofs"


#==================================
# Install Snap packages
#==================================
print_title "Install Snap Packages"

snap_install "spt" "spt"
snap_install "GitKraken" "gitkraken"
snap_install "VS Code" "code"
snap_install "1Password" "1password"

# #==================================
# # Install Cargo packages
# #==================================
# print_title "Install Cargo Packages"

# cargo_install "exa" "exa"

#==================================
# Install Flatpak Packages
#==================================
print_title "Install Flatpak Packages"

flatpak_install "Firefox" "org.mozilla.firefox"
flatpak_install "GitKraken" "com.axosoft.GitKraken"
flatpak_install "Insomnia" "rest.insomnia.Insomnia"
flatpak_install "Beekeeper Studio" "io.beekeeperstudio.Studio"
flatpak_install "Image Optimizer" "com.github.gijsgoudzwaard.image-optimizer"
flatpak_install "Mailspring" "com.getmailspring.Mailspring"
flatpak_install "Telegram" "org.telegram.desktop"
flatpak_install "Discord" "com.discordapp.Discord"
flatpak_install "Zoom" "us.zoom.Zoom"
flatpak_install "Dropbox" "com.dropbox.Client"
flatpak_install "Transmission" "com.transmissionbt.Transmission"
flatpak_install "Spotify" "com.spotify.Client"
flatpak_install "VLC" "org.videolan.VLC"
flatpak_install "Steam" "com.valvesoftware.Steam"


#==================================
# Install From Source
#==================================
print_title "Install Packages From Source"

# Tmux Plugin Manager (TPM)
execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"

# # Kitty
# curl -L --silent https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
# cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
# sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
curl -Lo lazygit.tar.gz --silent --output /dev/null "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
rm -rf lazygit.tar.gz
print_success "lazygit"

# NvChad
# rm -rf ~/.config/nvim
# rm -rf ~/.local/share/nvim
# rm -rf ~/.cache/nvim
# execute "git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1" "NvChad"

# Reversal Icons
wget -qO ~/reversal.tar.gz https://github.com/yeyushengfan258/Reversal-icon-theme/archive/master.tar.gz
mkdir -p ~/reversal-icons
tar --extract \
	--gzip \
	--file ~/reversal.tar.gz \
	--strip-components 1 \
	--directory ~/reversal-icons

cd ~/reversal-icons && . install.sh -a &> /dev/null
print_success "Reversal Icons"

rm -rf ~/reversal-icons
rm -rf ~/master.tar.gz


#==================================
# Install Extensions
#==================================
print_title "Install Gnome Extensions"

extension_install "Dash To Dock (COSMIC)" "https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/"
extension_install "User Themes" "https://extensions.gnome.org/extension/19/user-themes/"
extension_install "Blur My Shell" "https://extensions.gnome.org/extension/3193/blur-my-shell/"
extension_install "Rounded Corners" "https://extensions.gnome.org/extension/1514/rounded-corners/"
extension_install "Places Status Indicator" "https://extensions.gnome.org/extension/8/places-status-indicator/"
extension_install "Always Indicator" "https://extensions.gnome.org/extension/2594/always-indicator/"
extension_install "Removable Drive Menu" "https://extensions.gnome.org/extension/7/removable-drive-menu/"
extension_install "Caffeine" "https://extensions.gnome.org/extension/517/caffeine/"
extension_install "Impatience" "https://extensions.gnome.org/extension/277/impatience/"
extension_install "User Avatar" "https://extensions.gnome.org/extension/5506/user-avatar-in-quick-settings/"

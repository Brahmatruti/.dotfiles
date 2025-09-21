#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_debian.sh"


#==================================
# Print Section Title
#==================================
print_section "Setting up System Defaults"


#==================================
# Configure Git
#==================================
print_title "Configuring Git"

# Set git to use main as default branch
git config --global init.defaultBranch main

# Configure git credentials helper
git config --global credential.helper store

# Configure git user info (if not already set)
if ! git config --global user.name > /dev/null; then
    read -p "Enter your git username: " git_username
    git config --global user.name "$git_username"
fi

if ! git config --global user.email > /dev/null; then
    read -p "Enter your git email: " git_email
    git config --global user.email "$git_email"
fi

# Configure git editor
git config --global core.editor "nvim"

# Configure git diff and merge tools
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

print_success "Git configured successfully"


#==================================
# Configure Gnome Settings
#==================================
print_title "Configuring Gnome Settings"

# Set Gnome to prefer dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Configure touchpad settings
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Configure keyboard settings
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'us+intl')]"

# Configure power settings
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800

print_success "Gnome settings configured"


#==================================
# Configure Terminal
#==================================
print_title "Configuring Terminal"

# Set Alacritty as default terminal
if command -v update-alternatives &> /dev/null; then
    sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty
fi

print_success "Terminal configured"


#==================================
# Configure File Manager
#==================================
print_title "Configuring File Manager"

# Show hidden files by default
gsettings set org.gtk.Settings.FileChooser show-hidden true

# Configure Nautilus preferences
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences show-hidden-files true

print_success "File manager configured"

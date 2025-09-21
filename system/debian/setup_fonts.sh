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
print_section "Installing Fonts"


#==================================
# Install Fonts
#==================================
print_title "Install Fonts"

# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download and install Hack Nerd Font
print_title "Installing Hack Nerd Font"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip -O /tmp/Hack.zip
unzip -q /tmp/Hack.zip -d ~/.local/share/fonts/
fc-cache -f -v

# Download and install Fira Code Nerd Font
print_title "Installing Fira Code Nerd Font"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip -O /tmp/FiraCode.zip
unzip -q /tmp/FiraCode.zip -d ~/.local/share/fonts/
fc-cache -f -v

# Download and install JetBrains Mono Nerd Font
print_title "Installing JetBrains Mono Nerd Font"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
unzip -q /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -f -v

# Clean up
rm -f /tmp/Hack.zip /tmp/FiraCode.zip /tmp/JetBrainsMono.zip

print_success "Fonts installed successfully"
print_title "Font cache has been updated"

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
print_section "Setting up Shell Environment"


#==================================
# Install Shells
#==================================
print_title "Installing Shells"

# Install fish shell
apt_install "Fish Shell" "fish"

# Install zsh
apt_install "Zsh" "zsh"

# Install oh-my-zsh
print_title "Installing Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install oh-my-zsh plugins
print_title "Installing Oh My Zsh Plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

print_success "Shells installed"


#==================================
# Configure Fish Shell
#==================================
print_title "Configuring Fish Shell"

# Create fish config directory
mkdir -p ~/.config/fish

# Copy fish configuration
cp -r "$HOME/.dotfiles/config/fish/"* ~/.config/fish/

# Install fisher (fish package manager)
print_title "Installing Fisher"
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install fish plugins
print_title "Installing Fish Plugins"
fisher install jorgebucaran/nvm.fish
fisher install PatrickF1/fzf.fish
fisher install jethrokuan/z

print_success "Fish shell configured"


#==================================
# Configure Zsh
#==================================
print_title "Configuring Zsh"

# Copy zsh configuration
cp "$HOME/.dotfiles/config/zsh/.zshrc" ~/.zshrc

# Set zsh as default shell (optional)
if command -v zsh &> /dev/null && [ "$ZSH_VERSION" ]; then
    print_info "Zsh is already the default shell"
else
    read -p "Do you want to set Zsh as your default shell? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s $(which zsh)
        print_success "Zsh set as default shell"
    fi
fi

print_success "Zsh configured"


#==================================
# Configure Bash
#==================================
print_title "Configuring Bash"

# Copy bash configuration
cp "$HOME/.dotfiles/config/bash/.bashrc" ~/.bashrc
cp "$HOME/.dotfiles/config/bash/.bash_profile" ~/.bash_profile

# Source bash configuration
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

print_success "Bash configured"


#==================================
# Install Starship Prompt
#==================================
print_title "Installing Starship Prompt"

# Install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Add starship to shells
echo 'eval "$(starship init bash)"' >> ~/.bashrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
mkdir -p ~/.config/fish
echo 'starship init fish | source' >> ~/.config/fish/config.fish

print_success "Starship prompt installed"


#==================================
# Configure Tmux
#==================================
print_title "Configuring Tmux"

# Copy tmux configuration
cp "$HOME/.dotfiles/config/tmux/.tmux.conf" ~/.tmux.conf

# Install tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

print_success "Tmux configured"

#!/bin/bash
#==================================
# VSCode Extensions Installer (Linux/Unix)
#==================================
# This script installs VSCode extensions from the extensions.txt file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#==================================
# Functions
#==================================

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

#==================================
# Check VSCode Installation
#==================================

check_vscode() {
    if ! command -v code >/dev/null 2>&1; then
        print_error "VSCode is not installed or not in PATH"
        print_info "Please install VSCode first:"
        print_info "  - Ubuntu/Debian: sudo apt install code"
        print_info "  - Arch Linux: sudo pacman -S code"
        print_info "  - Fedora: sudo dnf install code"
        print_info "  - Or download from: https://code.visualstudio.com/"
        return 1
    fi
    print_success "VSCode found at: $(which code)"
    return 0
}

#==================================
# Install Extensions
#==================================

install_extensions() {
    local extensions_file="$HOME/.dotfiles/config/vscode/extensions.txt"

    if [ ! -f "$extensions_file" ]; then
        print_error "Extensions file not found: $extensions_file"
        return 1
    fi

    # Read extensions from file (ignore comments and empty lines)
    local extensions=()
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" ]] && continue
        [[ "$line" =~ ^[[:space:]]*# ]] && continue

        # Extract extension ID (everything before #)
        local extension_id=$(echo "$line" | sed 's/[[:space:]]*#.*//')
        extension_id=$(echo "$extension_id" | tr -d '[:space:]')

        if [ -n "$extension_id" ]; then
            extensions+=("$extension_id")
        fi
    done < "$extensions_file"

    if [ ${#extensions[@]} -eq 0 ]; then
        print_warning "No extensions found in extensions.txt"
        return 0
    fi

    print_info "Found ${#extensions[@]} extensions to install"

    local success_count=0
    local fail_count=0

    # Install each extension
    for extension in "${extensions[@]}"; do
        print_info "Installing $extension..."

        if code --install-extension "$extension" --force >/dev/null 2>&1; then
            print_success "$extension installed successfully"
            ((success_count++))
        else
            print_warning "Failed to install $extension"
            ((fail_count++))
        fi
    done

    print_info "Installation completed: $success_count successful, $fail_count failed"
    return $fail_count
}

#==================================
# List Installed Extensions
#==================================

list_installed_extensions() {
    print_info "Checking installed VSCode extensions..."

    if ! code --list-extensions >/dev/null 2>&1; then
        print_warning "Could not retrieve installed extensions"
        return 1
    fi

    local installed=$(code --list-extensions)
    if [ -n "$installed" ]; then
        print_success "Currently installed extensions:"
        echo "$installed" | while IFS= read -r extension; do
            echo -e "  ${BLUE}•${NC} $extension"
        done
    else
        print_info "No extensions currently installed"
    fi
}

#==================================
# Setup VSCode Configuration
#==================================

setup_vscode_config() {
    local config_dir="$HOME/.config/Code/User"
    local dotfiles_config_dir="$HOME/.dotfiles/config/vscode"

    print_info "Setting up VSCode configuration..."

    # Create config directory if it doesn't exist
    mkdir -p "$config_dir"

    # Copy settings.json if it exists
    if [ -f "$dotfiles_config_dir/settings.json" ]; then
        print_info "Copying VSCode settings..."
        cp "$dotfiles_config_dir/settings.json" "$config_dir/settings.json"
        print_success "VSCode settings copied to $config_dir/settings.json"
    else
        print_warning "No settings.json found in $dotfiles_config_dir"
    fi

    # Copy keybindings.json if it exists
    if [ -f "$dotfiles_config_dir/keybindings.json" ]; then
        print_info "Copying VSCode keybindings..."
        cp "$dotfiles_config_dir/keybindings.json" "$config_dir/keybindings.json"
        print_success "VSCode keybindings copied to $config_dir/keybindings.json"
    fi

    # Copy snippets if they exist
    if [ -d "$dotfiles_config_dir/snippets" ]; then
        print_info "Copying VSCode snippets..."
        cp -r "$dotfiles_config_dir/snippets" "$config_dir/"
        print_success "VSCode snippets copied to $config_dir/snippets"
    fi
}

#==================================
# Main Execution
#==================================

main() {
    print_info "VSCode Extensions Installer (Linux/Unix)"
    echo

    # Check if user wants to continue
    read -p "Do you want to install VSCode extensions? (y/N): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        print_info "Extension installation cancelled"
        exit 0
    fi

    echo

    # Check VSCode installation
    if ! check_vscode; then
        exit 1
    fi

    # Setup VSCode configuration
    setup_vscode_config
    echo

    # Install extensions
    if install_extensions; then
        print_success "All extensions installed successfully!"
    else
        print_warning "Some extensions failed to install"
    fi

    echo

    # Show installed extensions
    list_installed_extensions

    print_success "VSCode setup completed!"
}

#==================================
# Run Main Function
#==================================

main "$@"

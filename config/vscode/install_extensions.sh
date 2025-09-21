#!/bin/bash
# VSCode Extensions Installer for Linux/macOS
# This script installs VSCode extensions from the extensions.txt file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠  $1${NC}"
}

print_error() {
    echo -e "${RED}✗  $1${NC}"
}

# Function to install VSCode extensions
install_vscode_extensions() {
    print_info "Installing Visual Studio Code extensions..."

    # Check if VSCode is installed
    if ! command -v code &> /dev/null; then
        print_error "VSCode is not installed or not in PATH. Please install VSCode first."
        return 1
    fi

    # Read extensions from file
    local extensions_file="$SCRIPT_DIR/extensions.txt"
    if [[ ! -f "$extensions_file" ]]; then
        print_error "Extensions file not found: $extensions_file"
        return 1
    fi

    # Parse extensions (ignore comments and empty lines)
    local extensions=()
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" ]] && continue
        [[ "$line" =~ ^[[:space:]]*# ]] && continue

        # Extract extension ID (everything before #)
        extension_id=$(echo "$line" | sed 's/[[:space:]]*#.*//')
        extension_id=$(echo "$extension_id" | tr -d '[:space:]')

        if [[ -n "$extension_id" ]]; then
            extensions+=("$extension_id")
        fi
    done < "$extensions_file"

    if [[ ${#extensions[@]} -eq 0 ]]; then
        print_warning "No extensions found in extensions.txt"
        return 0
    fi

    print_success "Found ${#extensions[@]} extensions to install"

    # Install each extension
    local success_count=0
    local fail_count=0

    for extension in "${extensions[@]}"; do
        print_info "Installing $extension..."
        if code --install-extension "$extension" --force &>/dev/null; then
            print_success "$extension installed successfully"
            ((success_count++))
        else
            print_warning "Failed to install $extension"
            ((fail_count++))
        fi
    done

    print_success "VSCode extensions installation completed!"
    print_info "Successfully installed: $success_count extensions"
    if [[ $fail_count -gt 0 ]]; then
        print_warning "Failed to install: $fail_count extensions"
    fi
}

# Function to list installed extensions
list_installed_extensions() {
    print_info "Checking installed VSCode extensions..."

    if command -v code &> /dev/null; then
        local installed
        installed=$(code --list-extensions 2>/dev/null)
        if [[ -n "$installed" ]]; then
            print_success "Currently installed extensions:"
            echo "$installed" | sed 's/^/  - /'
        else
            print_info "No extensions currently installed."
        fi
    else
        print_error "VSCode is not installed or not in PATH."
    fi
}

# Main execution
main() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Check for confirmation flag
    if [[ "$1" != "--yes" ]] && [[ "$1" != "-y" ]]; then
        read -p "Do you want to install VSCode extensions? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Extension installation cancelled."
            exit 0
        fi
    fi

    # Install extensions
    install_vscode_extensions

    # Show installed extensions
    list_installed_extensions
}

# Run main function
main "$@"

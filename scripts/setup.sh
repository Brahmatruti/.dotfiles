#!/bin/bash

#==================================
# Variables
#==================================
declare GITHUB_REPOSITORY="Brahmatruti/.dotfiles"
declare DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/main"
declare DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/main/scripts/utils/utils.sh"

#==================================
# Settings
#==================================
declare DOTFILES_DIR="$HOME/.dotfiles"
declare MINIMUM_MACOS_VERSION="12.0"
declare MINIMUM_UBUNTU_VERSION="20.04"
declare MINIMUM_DEBIAN_VERSION="11.0"

#==================================
# Helper Functions
#==================================
download() {
    local url="$1"
    local output="$2"

    if command -v "curl" &> /dev/null; then
        curl \
            --location \
            --silent \
            --show-error \
            --output "$output" \
            "$url" \
                &> /dev/null

        return $?

    elif command -v "wget" &> /dev/null; then
        wget \
            --quiet \
            --output-document="$output" \
            "$url" \
                &> /dev/null

        return $?
    fi

    return 1
}

download_dotfiles() {
    local tmpFile=""

    print_title "Download and extract archive"
    tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_TARBALL_URL" "$tmpFile"
    print_result $? "Download archive" "true"

    mkdir -p "$DOTFILES_DIR"
    print_result $? "Create '$DOTFILES_DIR'" "true"

    # Extract archive in the `dotfiles` directory.
    extract "$tmpFile" "$DOTFILES_DIR"
    print_result $? "Extract archive" "true"

    rm -rf "$tmpFile"
    print_result $? "Remove archive"
}

download_utils() {
    local tmpFile=""

    tmpFile="$(mktemp /tmp/XXXXX)"
    download "$DOTFILES_UTILS_URL" "$tmpFile" \
        && . "$tmpFile" \
        && rm -rf "$tmpFile" \
        && return 0

   return 1

}

extract() {
    local archive="$1"
    local outputDir="$2"

    if command -v "tar" &> /dev/null; then
        tar \
            --extract \
            --gzip \
            --file "$archive" \
            --strip-components 1 \
            --directory "$outputDir"

        return $?
    fi

    return 1
}

verify_os() {
    local os_name="$(get_os)"
    local os_version="$(get_os_version)"

    # Check if the OS is `macOS` and supported
    if [ "$os_name" == "macos" ]; then
        if is_supported_version "$os_version" "$MINIMUM_MACOS_VERSION"; then
            print_success "$os_name $os_version is supported"
            return 0
        else
            print_error "Minimum MacOS $MINIMUM_MACOS_VERSION is required (current is $os_version)"
        fi

    # Check if the OS is `Ubuntu` and supported
    elif [ "$os_name" == "ubuntu" ]; then

        if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
            print_success "$os_name $os_version is supported"
            return 0
        else
            print_error "Minimum Ubuntu $MINIMUM_UBUNTU_VERSION is required (current is $os_version)"
        fi

    # Check if the OS is `Windows WSL` and supported
    elif [ "$os_name" == "wsl_ubuntu" ]; then
            print_success "Windows WSL on Ubuntu is supported"
            return 0
    
    # Check if the OS is `Arch` and supported
    elif [ "$os_name" == "arch" ]; then
        print_success "$os_name is supported"
        return 0

    # Check if the OS is `Alpine` and supported
    elif [ "$os_name" == "alpine" ]; then
        print_success "$os_name is supported"
        return 0

    # Check if the OS is `Debian` and supported
    elif [ "$os_name" == "debian" ]; then
        if is_supported_version "$os_version" "$MINIMUM_DEBIAN_VERSION"; then
            print_success "$os_name $os_version is supported"
            return 0
        else
            print_error "Minimum Debian $MINIMUM_DEBIAN_VERSION is required (current is $os_version)"
        fi

    # Check if the OS is RPM-based (Fedora, RHEL, CentOS, Rocky, AlmaLinux)
    elif [[ "$os_name" =~ ^(fedora|rhel|centos|rocky|almalinux)$ ]]; then
        print_warning "$os_name is detected but not fully supported yet"
        print_info "Attempting to use similar architecture..."
        return 0

    # Check if the OS is SUSE-based (openSUSE, SLES)
    elif [[ "$os_name" =~ ^(opensuse|sles)$ ]]; then
        print_warning "$os_name is detected but not fully supported yet"
        print_info "Attempting to use similar architecture..."
        return 0

    # Check if the OS is Arch-based (Manjaro, EndeavourOS)
    elif [[ "$os_name" =~ ^(manjaro|endeavouros)$ ]]; then
        print_success "$os_name is supported (Arch-based)"
        return 0

    # Check if the OS is Gentoo-based (Gentoo, Funtoo)
    elif [[ "$os_name" =~ ^(gentoo|funtoo)$ ]]; then
        print_warning "$os_name is detected but not fully supported yet"
        print_info "Attempting to use similar architecture..."
        return 0

    # Check if the OS is Void Linux
    elif [ "$os_name" == "void" ]; then
        print_warning "$os_name is detected but not fully supported yet"
        print_info "Attempting to use similar architecture..."
        return 0

    # Check if the OS is FreeBSD
    elif [ "$os_name" == "freebsd" ]; then
        print_warning "$os_name is detected but not fully supported yet"
        print_info "Attempting to use similar architecture..."
        return 0

    # Exit if not supported OS
    else
        print_error "$os_name is not supported."
        print_info "Supported OS types:"
        print_option "•" "macOS (12.0+)"
        print_option "•" "Ubuntu (20.04+)"
        print_option "•" "Debian (11.0+)"
        print_option "•" "Arch Linux"
        print_option "•" "Alpine Linux"
        print_option "•" "Windows WSL (Ubuntu)"
        print_option "•" "Fedora/RHEL/CentOS/Rocky/AlmaLinux (experimental)"
        print_option "•" "openSUSE/SLES (experimental)"
        print_option "•" "Manjaro/EndeavourOS (Arch-based)"
        print_option "•" "Gentoo/Funtoo (experimental)"
        print_option "•" "Void Linux (experimental)"
        print_option "•" "FreeBSD (experimental)"
    fi

    return 1
}

#==================================
# Error Handling Functions
#==================================
handle_installation_error() {
    local os_name="$1"
    local exit_code="$2"
    local log_file="$HOME/.dotfiles/logs/install_$(date +%Y%m%d_%H%M%S).log"

    mkdir -p "$HOME/.dotfiles/logs"

    print_error "Installation failed with exit code $exit_code"
    print_warning "Check logs at: $log_file"

    # Log the error
    echo "=== Installation Error Log ===" > "$log_file"
    echo "OS: $os_name" >> "$log_file"
    echo "Timestamp: $(date)" >> "$log_file"
    echo "Exit Code: $exit_code" >> "$log_file"
    echo "============================" >> "$log_file"

    # Ask user for action
    ask_for_error_action "$os_name" "$log_file"
}

ask_for_error_action() {
    local os_name="$1"
    local log_file="$2"

    print_question "What would you like to do?"
    print_option "1" "Retry installation"
    print_option "2" "Skip this step and continue"
    print_option "3" "View error log"
    print_option "4" "Exit installation"

    read -r choice
    case "$choice" in
        1) install_with_error_handling "$os_name" ;;
        2) print_warning "Skipping $os_name installation" ;;
        3) less "$log_file" ;;
        4) exit 1 ;;
        *) print_error "Invalid choice. Exiting." ; exit 1 ;;
    esac
}

install_with_error_handling() {
    local os_name="$1"
    local install_script="$HOME/.dotfiles/system/$os_name/install.sh"

    if [ -f "$install_script" ]; then
        if . "$install_script"; then
            print_success "Installation completed successfully"
        else
            handle_installation_error "$os_name" "$?"
        fi
    else
        print_error "Installation script not found: $install_script"
        handle_missing_script "$os_name"
    fi
}

handle_missing_script() {
    local os_name="$1"

    print_error "Installation script for $os_name not found"
    print_info "Available installation scripts:"

    for dir in "$HOME/.dotfiles/system"/*/; do
        if [ -d "$dir" ] && [ -f "$dir/install.sh" ]; then
            local dir_name=$(basename "$dir")
            print_option "•" "$dir_name"
        fi
    done

    print_question "Would you like to try a different OS installation? (y/n)"
    read -r choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        print_info "Available options:"
        select os_option in "$HOME/.dotfiles/system"/*/; do
            if [ -d "$os_option" ] && [ -f "$os_option/install.sh" ]; then
                local selected_os=$(basename "$os_option")
                print_info "Attempting installation for $selected_os..."
                install_with_error_handling "$selected_os"
                break
            fi
        done
    else
        print_error "Installation cannot continue without appropriate script"
        exit 1
    fi
}

#==================================
# Main Install Starter
#==================================
main() {

    # Ensure that the following actions are made relative to this file's path.
    cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

    # Load utils
    if [ -x "utils.sh" ]; then
        . "utils.sh" || exit 1
    else
        download_utils || exit 1
    fi

    print_section "Excalith Dotfiles Setup"

    # Ask user for sudo
    print_title "Sudo Access"
    ask_for_sudo

    # Verify OS and OS version
    print_title "Verifying OS"
    verify_os || exit 1

    # Check if this script was run directly (./<path>/setup.sh),
    # and if not, it most likely means that the dotfiles were not
    # yet set up, and they will need to be downloaded.
    printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null \
        || download_dotfiles

    # Start installation with error handling
    install_with_error_handling "$(get_os)"

    # Ask for git credentials
    . "$HOME/.dotfiles/scripts/utils/generate_git_creds.sh"

    # Ask for SSH (Disabled since I started using another method)
    #. "$HOME/.dotfiles/scripts/utils/generate_ssh.sh"

    # Ask for GPG (Disabled since I started using another method)
    #. "$HOME/.dotfiles/scripts/utils/generate_gpg.sh"

    # Link to original repository and update contents of dotfiles
    if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
        . "$HOME/.dotfiles/scripts/utils/init_dotfile_repo.sh '$DOTFILES_ORIGIN'"
    fi

    # Ask for restart
    . "$HOME/.dotfiles/scripts/utils/restart.sh"
}

main "$@"

#!/bin/bash

#==================================
# ENHANCED INSTALLATION UTILITIES
#==================================

# Source logging utilities
. "$HOME/.dotfiles/scripts/utils/utils_logging.sh"

#==================================
# Enhanced Installation Functions
#==================================

# Enhanced APT installation with retry logic and logging
apt_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    track_installation_attempt "$description" "$package"

    while [ $retry_count -lt $max_retries ]; do
        if execute "sudo apt-get install -y $package" "$description"; then
            track_installation_result "true" "$description" "$package" "Successfully installed"
            return 0
        else
            retry_count=$((retry_count + 1))
            local reason="Attempt $retry_count failed"

            if [ $retry_count -lt $max_retries ]; then
                log_warning "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    local reason="Failed to install after $max_retries attempts"
    track_installation_result "false" "$description" "$package" "$reason"
    return 1
}

# Enhanced Snap installation with retry logic and logging
snap_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    track_installation_attempt "$description" "$package"

    while [ $retry_count -lt $max_retries ]; do
        if execute "sudo snap install $package" "$description"; then
            track_installation_result "true" "$description" "$package" "Successfully installed"
            return 0
        else
            retry_count=$((retry_count + 1))
            local reason="Attempt $retry_count failed"

            if [ $retry_count -lt $max_retries ]; then
                log_warning "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    local reason="Failed to install after $max_retries attempts"
    track_installation_result "false" "$description" "$package" "$reason"
    return 1
}

# Enhanced Flatpak installation with retry logic and logging
flatpak_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    track_installation_attempt "$description" "$package"

    while [ $retry_count -lt $max_retries ]; do
        if execute "flatpak install -y flathub $package" "$description"; then
            track_installation_result "true" "$description" "$package" "Successfully installed"
            return 0
        else
            retry_count=$((retry_count + 1))
            local reason="Attempt $retry_count failed"

            if [ $retry_count -lt $max_retries ]; then
                log_warning "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    local reason="Failed to install after $max_retries attempts"
    track_installation_result "false" "$description" "$package" "$reason"
    return 1
}

# Enhanced Brew installation with retry logic and logging
brew_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    track_installation_attempt "$description" "$package"

    while [ $retry_count -lt $max_retries ]; do
        if execute "brew install $package" "$description"; then
            track_installation_result "true" "$description" "$package" "Successfully installed"
            return 0
        else
            retry_count=$((retry_count + 1))
            local reason="Attempt $retry_count failed"

            if [ $retry_count -lt $max_retries ]; then
                log_warning "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    local reason="Failed to install after $max_retries attempts"
    track_installation_result "false" "$description" "$package" "$reason"
    return 1
}

# Enhanced Chocolatey installation with retry logic and logging
choco_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    track_installation_attempt "$description" "$package"

    while [ $retry_count -lt $max_retries ]; do
        if execute "choco install -y $package" "$description"; then
            track_installation_result "true" "$description" "$package" "Successfully installed"
            return 0
        else
            retry_count=$((retry_count + 1))
            local reason="Attempt $retry_count failed"

            if [ $retry_count -lt $max_retries ]; then
                log_warning "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    local reason="Failed to install after $max_retries attempts"
    track_installation_result "false" "$description" "$package" "$reason"
    return 1
}

# Enhanced Winget installation with retry logic and logging
winget_install_with_retry() {
    local description="$1"
    local package="$2"
    local max_retries=2
    local retry_count=0

    track_installation_attempt "$description" "$package"

    while [ $retry_count -lt $max_retries ]; do
        if execute "winget install -e --id $package" "$description"; then
            track_installation_result "true" "$description" "$package" "Successfully installed"
            return 0
        else
            retry_count=$((retry_count + 1))
            local reason="Attempt $retry_count failed"

            if [ $retry_count -lt $max_retries ]; then
                log_warning "Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    local reason="Failed to install after $max_retries attempts"
    track_installation_result "false" "$description" "$package" "$reason"
    return 1
}

#==================================
# Enhanced Package Installation Wrappers
#==================================

# Enhanced APT installation with comprehensive error handling
apt_install() {
    local description="$1"
    local package="$2"

    if ! dpkg -l "$package" 2>/dev/null | grep -q "^ii"; then
        if apt_install_with_retry "$description" "$package"; then
            log_success "$package" "$description"
        else
            handle_package_error "$description" "$package"
        fi
    else
        log_skipped "$package" "$description" "Already installed"
    fi
}

# Enhanced Snap installation with comprehensive error handling
snap_install() {
    local description="$1"
    local package="$2"

    if ! snap list "$package" 2>/dev/null | grep -q "$package"; then
        if snap_install_with_retry "$description" "$package"; then
            log_success "$package" "$description"
        else
            handle_package_error "$description" "$package"
        fi
    else
        log_skipped "$package" "$description" "Already installed"
    fi
}

# Enhanced Flatpak installation with comprehensive error handling
flatpak_install() {
    local description="$1"
    local package="$2"

    if ! flatpak list --app | grep -q "$package"; then
        if flatpak_install_with_retry "$description" "$package"; then
            log_success "$package" "$description"
        else
            handle_package_error "$description" "$package"
        fi
    else
        log_skipped "$package" "$description" "Already installed"
    fi
}

# Enhanced Brew installation with comprehensive error handling
brew_install() {
    local description="$1"
    local package="$2"

    if ! brew list "$package" 2>/dev/null | grep -q "$package"; then
        if brew_install_with_retry "$description" "$package"; then
            log_success "$package" "$description"
        else
            handle_package_error "$description" "$package"
        fi
    else
        log_skipped "$package" "$description" "Already installed"
    fi
}

# Enhanced Chocolatey installation with comprehensive error handling
choco_install() {
    local description="$1"
    local package="$2"

    if ! choco list --local-only "$package" 2>/dev/null | grep -q "$package"; then
        if choco_install_with_retry "$description" "$package"; then
            log_success "$package" "$description"
        else
            handle_package_error "$description" "$package"
        fi
    else
        log_skipped "$package" "$description" "Already installed"
    fi
}

# Enhanced Winget installation with comprehensive error handling
winget_install() {
    local description="$1"
    local package="$2"

    if ! winget list "$package" 2>/dev/null | grep -q "$package"; then
        if winget_install_with_retry "$description" "$package"; then
            log_success "$package" "$description"
        else
            handle_package_error "$description" "$package"
        fi
    else
        log_skipped "$package" "$description" "Already installed"
    fi
}

#==================================
# Enhanced Error Handling
#==================================

handle_package_error() {
    local description="$1"
    local package="$2"

    local reason="Installation failed"
    log_failure "$package" "$description" "$reason"

    log_warning "Package $description ($package) failed to install"
    log_info "Would you like to continue with other packages? (y/n)"

    # Auto-continue after 3 seconds with default 'y'
    local choice=""
    read -t 3 -r choice
    if [ $? -gt 128 ]; then
        # Timeout occurred (no input within 3 seconds)
        log_info "No response received within 3 seconds, continuing automatically..."
        choice="y"
    fi

    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        log_error "Installation cannot continue. Exiting."
        print_installation_summary
        exit 1
    fi
}

#==================================
# GPG Key Management
#==================================

# Enhanced GPG key installation with existence checks
install_gpg_key() {
    local key_url="$1"
    local description="$2"
    local keyring_path="${3:-/usr/share/keyrings/archive-keyring.gpg}"

    if [ ! -f "$keyring_path" ]; then
        log_info "Installing $description GPG key..."
        if execute "curl -fsSL $key_url | sudo gpg --dearmor -o $keyring_path" "$description GPG Key"; then
            log_success "gpg_key" "$description GPG Key"
        else
            log_failure "gpg_key" "$description GPG Key" "Failed to download or install"
        fi
    else
        log_skipped "gpg_key" "$description GPG Key" "Already exists"
    fi
}

#==================================
# Export Functions
#==================================

# Make functions available to other scripts
export -f apt_install_with_retry
export -f snap_install_with_retry
export -f flatpak_install_with_retry
export -f brew_install_with_retry
export -f choco_install_with_retry
export -f winget_install_with_retry
export -f apt_install
export -f snap_install
export -f flatpak_install
export -f brew_install
export -f choco_install
export -f winget_install
export -f handle_package_error
export -f install_gpg_key

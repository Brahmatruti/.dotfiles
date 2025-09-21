#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Enhanced Debian Setup with User Configuration
#==================================

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_debian.sh"
. "$HOME/.dotfiles/scripts/utils/utils_logging.sh"
. "$HOME/.dotfiles/scripts/utils/utils_installation.sh"
. "$HOME/.dotfiles/scripts/utils/utils_user_config.sh"

#==================================
# Main Setup Function
#==================================

main() {
    print_section "Enhanced Debian Setup"

    # Check if user configuration exists
    if ! load_user_config; then
        print_info "No user configuration found. Let's set up your preferences first."
        collect_user_config
        show_config_summary

        if ! ask_yes_no "Do you want to continue with this configuration?" "y"; then
            print_info "Setup cancelled. You can run this script again to reconfigure."
            exit 0
        fi
    fi

    # Configure Git
    configure_git

    # Install packages based on user preferences
    install_by_categories

    # Configure NFS if enabled
    configure_nfs

    # Final summary
    print_installation_summary
}

#==================================
# Git Configuration
#==================================

configure_git() {
    if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
        print_title "Configuring Git"

        git config --global user.name "$GIT_USER_NAME"
        git config --global user.email "$GIT_USER_EMAIL"

        # Set other useful git configurations
        git config --global init.defaultBranch main
        git config --global core.editor "nano"
        git config --global pull.rebase false
        git config --global credential.helper store

        print_success "Git configured with user: $GIT_USER_NAME <$GIT_USER_EMAIL>"
    else
        print_warning "Git configuration skipped (no user details provided)"
    fi
}

#==================================
# Category-based Installation
#==================================

install_by_categories() {
    print_title "Installing Packages by Category"

    local installed_count=0
    local skipped_count=0

    for category in "${SELECTED_CATEGORIES[@]}"; do
        print_header "Installing $category"

        # Get packages for this category
        local packages_var="PACKAGES_$(echo "$category" | tr ' ' '_' | tr '[:lower:]' '[:upper:]')"
        local packages="${!packages_var}"

        if [ -z "$packages" ]; then
            print_warning "No packages defined for category: $category"
            continue
        fi

        # Convert comma-separated string to array
        IFS=',' read -ra package_array <<< "$packages"

        for package in "${package_array[@]}"; do
            # Trim whitespace
            package=$(echo "$package" | xargs)

            if [ -n "$package" ]; then
                # Check if this is a development package and skip if not development machine
                if [[ "$category" == *"Development"* ]] && [ "$IS_DEVELOPMENT_MACHINE" != "true" ]; then
                    print_info "Skipping development package: $package (not a development machine)"
                    log_skipped "$package" "$package" "Development package on non-development machine"
                    ((skipped_count++))
                    continue
                fi

                # Install the package
                if install_package_by_category "$category" "$package"; then
                    ((installed_count++))
                else
                    ((skipped_count++))
                fi
            fi
        done
    done

    print_info "Category installation complete: $installed_count installed, $skipped_count skipped"
}

install_package_by_category() {
    local category="$1"
    local package="$2"

    case "$category" in
        "Essential Tools")
            install_essential_package "$package"
            ;;
        "Development Tools")
            install_development_package "$package"
            ;;
        "Programming Languages")
            install_language_package "$package"
            ;;
        "Container Tools")
            install_container_package "$package"
            ;;
        "Infrastructure")
            install_infrastructure_package "$package"
            ;;
        "Editors & IDE")
            install_editor_package "$package"
            ;;
        "Media Tools")
            install_media_package "$package"
            ;;
        "Communication")
            install_communication_package "$package"
            ;;
        "Cloud Storage")
            install_cloud_package "$package"
            ;;
        "Browsers")
            install_browser_package "$package"
            ;;
        "Gaming")
            install_gaming_package "$package"
            ;;
        "System Tools")
            install_system_package "$package"
            ;;
        "Development Environment")
            install_dev_env_package "$package"
            ;;
        *)
            print_warning "Unknown category: $category for package: $package"
            return 1
            ;;
    esac

    return 0
}

#==================================
# Package Installation by Category
#==================================

install_essential_package() {
    local package="$1"
    apt_install "Essential: $package" "$package"
}

install_development_package() {
    local package="$1"
    if [ "$IS_DEVELOPMENT_MACHINE" = "true" ]; then
        apt_install "Dev Tool: $package" "$package"
    else
        log_skipped "$package" "$package" "Development package on non-development machine"
    fi
}

install_language_package() {
    local package="$1"
    if [ "$IS_DEVELOPMENT_MACHINE" = "true" ]; then
        apt_install "Language: $package" "$package"
    else
        log_skipped "$package" "$package" "Language package on non-development machine"
    fi
}

install_container_package() {
    local package="$1"
    if [ "$IS_DEVELOPMENT_MACHINE" = "true" ]; then
        apt_install "Container: $package" "$package"
    else
        log_skipped "$package" "$package" "Container tool on non-development machine"
    fi
}

install_infrastructure_package() {
    local package="$1"
    if [ "$IS_DEVELOPMENT_MACHINE" = "true" ]; then
        apt_install "Infrastructure: $package" "$package"
    else
        log_skipped "$package" "$package" "Infrastructure tool on non-development machine"
    fi
}

install_editor_package() {
    local package="$1"
    apt_install "Editor: $package" "$package"
}

install_media_package() {
    local package="$1"
    apt_install "Media: $package" "$package"
}

install_communication_package() {
    local package="$1"
    apt_install "Communication: $package" "$package"
}

install_cloud_package() {
    local package="$1"
    apt_install "Cloud: $package" "$package"
}

install_browser_package() {
    local package="$1"
    apt_install "Browser: $package" "$package"
}

install_gaming_package() {
    local package="$1"
    apt_install "Gaming: $package" "$package"
}

install_system_package() {
    local package="$1"
    apt_install "System: $package" "$package"
}

install_dev_env_package() {
    local package="$1"
    if [ "$IS_DEVELOPMENT_MACHINE" = "true" ]; then
        apt_install "Dev Env: $package" "$package"
    else
        log_skipped "$package" "$package" "Dev environment tool on non-development machine"
    fi
}

#==================================
# NFS Configuration
#==================================

configure_nfs() {
    if [ "$NFS_ENABLED" = "true" ]; then
        print_title "Configuring NFS"

        # Install NFS packages
        apt_install "NFS Common" "nfs-common"
        apt_install "Autofs" "autofs"

        if [ "$NFS_AUTO_MOUNT" = "true" ]; then
            print_info "NFS auto-mounting enabled"
            # Additional autofs configuration would go here
        else
            print_info "NFS installed but auto-mounting disabled"
        fi
    else
        print_info "NFS support not requested"
    fi
}

#==================================
# Run Main Function
#==================================

main "$@"

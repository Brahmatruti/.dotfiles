#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"


initialize_git_repository() {
    declare -r GIT_ORIGIN="$1"

    if [ -z "$GIT_ORIGIN" ]; then
        print_error "Please provide a URL for the Git origin"
        exit 1
    fi

    # Get the dotfiles directory path
    declare -r DOTFILES_DIR="$HOME/.dotfiles"

    # Check if dotfiles directory exists
    if [ ! -d "$DOTFILES_DIR" ]; then
        print_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi

    # Check repository already initialized
    if ! is_git_repository; then
        # Run the following Git commands in the root of
        # the dotfiles directory
        cd "$DOTFILES_DIR" \
            || print_error "Failed to change to dotfiles directory: $DOTFILES_DIR"

        execute \
            "git init && git remote add origin $GIT_ORIGIN" \
            "Initialize git repository"
    fi
}

main() {
    print_section "Initialize Git Repository"
    initialize_git_repository "$1"
}

main "$1"

#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTILS_FILE="$SCRIPT_DIR/utils.sh"

# Source utils if it exists
if [ -f "$UTILS_FILE" ]; then
    . "$UTILS_FILE"
else
    # Fallback to default path
    . "$HOME/.dotfiles/scripts/utils/utils.sh"
fi

#==================================
# Git Credentials Generation
#==================================

main() {
    print_section "Git Credentials"

    ask_for_confirmation "Do you want to update Git Credentials?"
    printf "\n"

    if answer_is_yes; then
        ask "Git Username: "
        local username="$(get_answer)"

        ask "Git E-Mail  : "
        local email="$(get_answer)"

        # Create the git config directory if it doesn't exist
        mkdir -p ~/.config/git

        # Create or update the local git config file
        cat > ~/.config/git/.gitconfig.local << EOF
[user]
    name = $username
    email = $email
EOF

        printf "\n"
        print_result $? "Generate git credentials"
    else
        print_warning "Skipped git credentials setup"
    fi
}

main

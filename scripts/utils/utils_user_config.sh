#!/bin/bash

#==================================
# USER CONFIGURATION UTILITIES
#==================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration file location
CONFIG_FILE="$HOME/.dotfiles/user_config.sh"

#==================================
# User Configuration Functions
#==================================

ask_yes_no() {
    local question="$1"
    local default="${2:-n}"

    while true; do
        echo -e "${BLUE}❓${NC} $question"
        if [ "$default" = "y" ]; then
            echo -e "${CYAN}(Y/n)${NC}: \c"
        else
            echo -e "${CYAN}(y/N)${NC}: \c"
        fi

        read -t 10 -r answer
        if [ $? -gt 128 ]; then
            # Timeout occurred
            echo -e "\n${YELLOW}⏰ Timeout - defaulting to $default${NC}"
            answer="$default"
        fi

        case "$answer" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            "")
                if [ "$default" = "y" ]; then
                    return 0
                else
                    return 1
                fi
                ;;
            *)
                echo -e "${RED}❌ Please answer yes or no${NC}"
                ;;
        esac
    done
}

ask_with_options() {
    local question="$1"
    local options=("${@:2}")
    local default="${options[0]}"

    echo -e "${BLUE}❓${NC} $question"
    for i in "${!options[@]}"; do
        if [ "${options[$i]}" = "$default" ]; then
            echo -e "${CYAN}$((i+1)). ${options[$i]} (default)${NC}"
        else
            echo -e "${CYAN}$((i+1)). ${options[$i]}${NC}"
        fi
    done

    while true; do
        echo -e "${CYAN}Enter your choice (1-${#options[@]}):${NC} \c"
        read -t 15 -r answer
        if [ $? -gt 128 ]; then
            # Timeout occurred
            echo -e "\n${YELLOW}⏰ Timeout - selecting default: $default${NC}"
            return 0
        fi

        if [ -z "$answer" ]; then
            echo "$default"
            return 0
        fi

        if [ "$answer" -ge 1 ] && [ "$answer" -le "${#options[@]}" ] 2>/dev/null; then
            echo "${options[$((answer-1))]}"
            return 0
        fi

        echo -e "${RED}❌ Invalid choice. Please select 1-${#options[@]}${NC}"
    done
}

ask_for_input() {
    local question="$1"
    local default="$2"
    local variable_name="$3"

    echo -e "${BLUE}❓${NC} $question"
    if [ -n "$default" ]; then
        echo -e "${CYAN}(Default: $default)${NC}"
    fi

    while true; do
        echo -e "${CYAN}Enter value:${NC} \c"
        read -t 30 -r input
        if [ $? -gt 128 ]; then
            # Timeout occurred
            if [ -n "$default" ]; then
                echo -e "\n${YELLOW}⏰ Timeout - using default: $default${NC}"
                input="$default"
            else
                echo -e "\n${RED}❌ Timeout - this field is required${NC}"
                continue
            fi
        fi

        if [ -z "$input" ] && [ -n "$default" ]; then
            input="$default"
        fi

        if [ -z "$input" ]; then
            echo -e "${RED}❌ This field cannot be empty${NC}"
            continue
        fi

        echo "$input"
        return 0
    done
}

#==================================
# Software Categories
#==================================

get_software_categories() {
    cat << 'EOF'
📱 Essential Tools (Terminal, File Managers, Basic Utilities)
🛠️  Development Tools (Compilers, Build Tools, Version Control)
💻 Programming Languages (Python, Node.js, Java, etc.)
🐳 Container Tools (Docker, Kubernetes Tools)
🏗️  Infrastructure (Ansible, Terraform, Cloud CLI)
📝 Editors & IDE (Neovim, VS Code, Micro)
🎨 Media Tools (Video, Audio, Graphics)
💬 Communication (Discord, Slack, Zoom, Teams)
☁️  Cloud Storage (Google Drive, pCloud, Mega, Synology)
🌐 Browsers (Firefox, Chrome, Brave)
🎮 Gaming (Steam, Game Launchers)
🖥️  System Tools (Monitoring, System Utilities)
🔧 Development Environment (SDKs, Runtimes, Libraries)
EOF
}

get_category_packages() {
    local category="$1"

    case "$category" in
        "Essential Tools")
            echo "tmux,less,eza,bat,tree,fasd,fd-find,fzf,ripgrep,gum,htop,httpie,prettyping,mtr,tldr,neofetch,ranger,midnight-commander"
            ;;
        "Development Tools")
            echo "build-essential,git,git-all,git-lfs,cargo,gcc,g++,make,cmake,unzip,jq,openssl-dev,libssl-dev"
            ;;
        "Programming Languages")
            echo "python3,python3-venv,python3-pip,nodejs,yarn,npm,openjdk-17-jdk"
            ;;
        "Container Tools")
            echo "docker-ce,docker-ce-cli,containerd.io,docker-compose-plugin"
            ;;
        "Infrastructure")
            echo "ansible,terraform"
            ;;
        "Editors & IDE")
            echo "neovim,micro,code"
            ;;
        "Media Tools")
            echo "ffmpeg,vlc,obs-studio,handbrake,blender"
            ;;
        "Communication")
            echo "discord,slack,zoom,telegram-desktop,whatsapp"
            ;;
        "Cloud Storage")
            echo "pcloud,megasync,synology-drive,rclone"
            ;;
        "Browsers")
            echo "firefox,google-chrome,brave-browser"
            ;;
        "Gaming")
            echo "steam,epicgameslauncher"
            ;;
        "System Tools")
            echo "gnome-tweaks,gnome-shell-extensions,htop,neofetch,fastfetch"
            ;;
        "Development Environment")
            echo "vscode,gitkraken,insomnia,beekeeper-studio,postman"
            ;;
        *)
            echo ""
            ;;
    esac
}

#==================================
# Configuration Collection
#==================================

collect_user_config() {
    print_header "User Configuration Setup"

    echo -e "${PURPLE}This setup will ask for your preferences to customize the installation.${NC}"
    echo -e "${PURPLE}You can skip any section or choose defaults by pressing Enter or waiting.${NC}"
    echo ""

    # Git Configuration
    print_header "Git Configuration"
    GIT_USER_NAME=$(ask_for_input "Enter your git username" "")
    GIT_USER_EMAIL=$(ask_for_input "Enter your git email" "")

    # Development Machine
    print_header "Machine Type"
    if ask_yes_no "Is this a development machine? (Will install dev tools, languages, etc.)" "y"; then
        IS_DEVELOPMENT_MACHINE="true"
    else
        IS_DEVELOPMENT_MACHINE="false"
    fi

    # NFS Configuration
    print_header "NFS Configuration"
    if ask_yes_no "Do you need NFS (Network File System) support?" "n"; then
        NFS_ENABLED="true"
        NFS_AUTO_MOUNT=$(ask_yes_no "Enable automatic NFS mounting?" "y")
    else
        NFS_ENABLED="false"
        NFS_AUTO_MOUNT="false"
    fi

    # Software Categories
    print_header "Software Categories"

    echo -e "${BLUE}📋 Available software categories:${NC}"
    get_software_categories

    echo ""
    echo -e "${YELLOW}Select categories to install (comma-separated numbers):${NC}"
    echo -e "${CYAN}Example: 1,3,5,7 (Essential Tools, Programming Languages, Editors, Browsers)${NC}"
    echo ""

    local categories=("Essential Tools" "Development Tools" "Programming Languages" "Container Tools" "Infrastructure" "Editors & IDE" "Media Tools" "Communication" "Cloud Storage" "Browsers" "Gaming" "System Tools" "Development Environment")

    SELECTED_CATEGORIES=()
    for i in "${!categories[@]}"; do
        if ask_yes_no "Install ${categories[$i]}?" "y"; then
            SELECTED_CATEGORIES+=("${categories[$i]}")
        fi
    done

    # Generate configuration file
    generate_config_file
}

generate_config_file() {
    cat > "$CONFIG_FILE" << EOF
#!/bin/bash
#==================================
# User Configuration
# Generated on $(date)
#==================================

# Git Configuration
export GIT_USER_NAME="$GIT_USER_NAME"
export GIT_USER_EMAIL="$GIT_USER_EMAIL"

# Machine Type
export IS_DEVELOPMENT_MACHINE="$IS_DEVELOPMENT_MACHINE"

# NFS Configuration
export NFS_ENABLED="$NFS_ENABLED"
export NFS_AUTO_MOUNT="$NFS_AUTO_MOUNT"

# Selected Software Categories
export SELECTED_CATEGORIES="${SELECTED_CATEGORIES[*]}"

# Package Lists by Category
EOF

    for category in "${SELECTED_CATEGORIES[@]}"; do
        packages=$(get_category_packages "$category")
        echo "export PACKAGES_$(echo "$category" | tr ' ' '_' | tr '[:lower:]' '[:upper:]')=\"$packages\"" >> "$CONFIG_FILE"
    done

    echo -e "${GREEN}✅ Configuration saved to $CONFIG_FILE${NC}"
}

load_user_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
        print_success "User configuration loaded"
        return 0
    else
        print_warning "No user configuration found"
        return 1
    fi
}

show_config_summary() {
    print_header "Configuration Summary"

    echo -e "${BLUE}📋 Git Configuration:${NC}"
    echo -e "  User Name: ${CYAN}$GIT_USER_NAME${NC}"
    echo -e "  User Email: ${CYAN}$GIT_USER_EMAIL${NC}"

    echo ""
    echo -e "${BLUE}💻 Machine Type:${NC}"
    echo -e "  Development Machine: ${CYAN}$IS_DEVELOPMENT_MACHINE${NC}"

    echo ""
    echo -e "${BLUE}🌐 NFS Configuration:${NC}"
    echo -e "  NFS Enabled: ${CYAN}$NFS_ENABLED${NC}"
    if [ "$NFS_ENABLED" = "true" ]; then
        echo -e "  Auto Mount: ${CYAN}$NFS_AUTO_MOUNT${NC}"
    fi

    echo ""
    echo -e "${BLUE}📦 Software Categories:${NC}"
    if [ ${#SELECTED_CATEGORIES[@]} -eq 0 ]; then
        echo -e "  ${YELLOW}None selected${NC}"
    else
        for category in "${SELECTED_CATEGORIES[@]}"; do
            echo -e "  ${GREEN}✓${NC} $category"
        done
    fi

    echo ""
    echo -e "${PURPLE}This configuration will be used to customize your installation.${NC}"
}

#==================================
# Export Functions
#==================================

export -f ask_yes_no
export -f ask_with_options
export -f ask_for_input
export -f collect_user_config
export -f generate_config_file
export -f load_user_config
export -f show_config_summary
export -f get_software_categories
export -f get_category_packages

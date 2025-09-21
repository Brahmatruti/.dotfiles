#!/bin/bash

#==================================
# Enhanced Debian Setup Demo
#==================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#==================================
# Demo Functions
#==================================

print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${PURPLE}DEMO: $1${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}⟲${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

#==================================
# Demo Main Function
#==================================

demo_enhanced_setup() {
    print_header "Enhanced Debian Setup with User Configuration"

    echo -e "${PURPLE}This demo shows the new enhanced setup system that:${NC}"
    echo -e "${BLUE}• Asks for user preferences upfront${NC}"
    echo -e "${BLUE}• Groups software into categories${NC}"
    echo -e "${BLUE}• Configures git with user details${NC}"
    echo -e "${BLUE}• Handles NFS configuration${NC}"
    echo -e "${BLUE}• Only installs what the user wants${NC}"
    echo ""

    # Demo 1: Show software categories
    print_header "1. Software Categories"
    echo -e "${BLUE}The system groups software into logical categories:${NC}"
    echo ""

    # Source the utility to get categories
    . "$HOME/.dotfiles/scripts/utils/utils_user_config.sh"

    get_software_categories
    echo ""

    # Demo 2: Show category packages
    print_header "2. Packages by Category"
    echo -e "${BLUE}Each category contains relevant packages:${NC}"
    echo ""

    local categories=("Essential Tools" "Development Tools" "Programming Languages" "Container Tools" "Infrastructure" "Editors & IDE" "Media Tools" "Communication" "Cloud Storage" "Browsers")

    for category in "${categories[@]}"; do
        packages=$(get_category_packages "$category")
        if [ -n "$packages" ]; then
            echo -e "${CYAN}$category:${NC}"
            echo -e "  ${GREEN}•${NC} $(echo "$packages" | tr ',' '\n  • ')"
            echo ""
        fi
    done

    # Demo 3: Show configuration questions
    print_header "3. User Configuration Questions"
    echo -e "${BLUE}The setup asks these questions at the beginning:${NC}"
    echo ""

    echo -e "${PURPLE}📋 Git Configuration:${NC}"
    echo -e "${CYAN}❓ Enter your git username${NC}"
    echo -e "${CYAN}❓ Enter your git email${NC}"
    echo ""

    echo -e "${PURPLE}💻 Machine Type:${NC}"
    echo -e "${CYAN}❓ Is this a development machine? (Y/n)${NC}"
    echo -e "${BLUE}   (Will install dev tools, languages, etc.)${NC}"
    echo ""

    echo -e "${PURPLE}🌐 NFS Configuration:${NC}"
    echo -e "${CYAN}❓ Do you need NFS (Network File System) support? (y/N)${NC}"
    echo -e "${CYAN}❓ Enable automatic NFS mounting? (Y/n)${NC}"
    echo ""

    echo -e "${PURPLE}📦 Software Categories:${NC}"
    echo -e "${CYAN}❓ Install Essential Tools? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Development Tools? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Programming Languages? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Container Tools? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Infrastructure Tools? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Editors & IDE? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Media Tools? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Communication Tools? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Cloud Storage? (Y/n)${NC}"
    echo -e "${CYAN}❓ Install Browsers? (Y/n)${NC}"
    echo ""

    # Demo 4: Show configuration summary
    print_header "4. Configuration Summary"
    echo -e "${BLUE}After collecting preferences, the system shows a summary:${NC}"
    echo ""

    echo -e "${CYAN}📋 Git Configuration:${NC}"
    echo -e "  User Name: ${GREEN}John Doe${NC}"
    echo -e "  User Email: ${GREEN}john.doe@example.com${NC}"
    echo ""

    echo -e "${CYAN}💻 Machine Type:${NC}"
    echo -e "  Development Machine: ${GREEN}true${NC}"
    echo ""

    echo -e "${CYAN}🌐 NFS Configuration:${NC}"
    echo -e "  NFS Enabled: ${GREEN}false${NC}"
    echo ""

    echo -e "${CYAN}📦 Software Categories:${NC}"
    echo -e "  ${GREEN}✓${NC} Essential Tools"
    echo -e "  ${GREEN}✓${NC} Development Tools"
    echo -e "  ${GREEN}✓${NC} Programming Languages"
    echo -e "  ${GREEN}✓${NC} Container Tools"
    echo -e "  ${GREEN}✓${NC} Infrastructure"
    echo -e "  ${GREEN}✓${NC} Editors & IDE"
    echo -e "  ${RED}✗${NC} Media Tools"
    echo -e "  ${RED}✗${NC} Communication"
    echo -e "  ${RED}✗${NC} Cloud Storage"
    echo -e "  ${RED}✗${NC} Browsers"
    echo ""

    # Demo 5: Show installation process
    print_header "5. Installation Process"
    echo -e "${BLUE}The installation then proceeds by category:${NC}"
    echo ""

    echo -e "${PURPLE}⟲ Installing Essential Tools...${NC}"
    echo -e "  ${GREEN}✓${NC} Essential: tmux"
    echo -e "  ${GREEN}✓${NC} Essential: less"
    echo -e "  ${GREEN}✓${NC} Essential: eza"
    echo -e "  ${GREEN}✓${NC} Essential: bat"
    echo ""

    echo -e "${PURPLE}⟲ Installing Development Tools...${NC}"
    echo -e "  ${GREEN}✓${NC} Dev Tool: git"
    echo -e "  ${GREEN}✓${NC} Dev Tool: build-essential"
    echo -e "  ${GREEN}✓${NC} Dev Tool: curl"
    echo -e "  ${GREEN}✓${NC} Dev Tool: wget"
    echo ""

    echo -e "${PURPLE}⟲ Installing Programming Languages...${NC}"
    echo -e "  ${GREEN}✓${NC} Language: python3"
    echo -e "  ${GREEN}✓${NC} Language: nodejs"
    echo -e "  ${GREEN}✓${NC} Language: openjdk-17-jdk"
    echo ""

    # Demo 6: Show final summary
    print_header "6. Installation Summary"
    echo -e "${BLUE}At the end, a comprehensive summary is shown:${NC}"
    echo ""

    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${PURPLE}INSTALLATION SUMMARY${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${GREEN}✓ SUCCESSFUL PACKAGES (12):${NC}"
    echo -e "  ${GREEN}•${NC} Essential: tmux"
    echo -e "  ${GREEN}•${NC} Essential: less"
    echo -e "  ${GREEN}•${NC} Essential: eza"
    echo -e "  ${GREEN}•${NC} Essential: bat"
    echo -e "  ${GREEN}•${NC} Dev Tool: git"
    echo -e "  ${GREEN}•${NC} Dev Tool: build-essential"
    echo -e "  ${GREEN}•${NC} Language: python3"
    echo -e "  ${GREEN}•${NC} Language: nodejs"
    echo ""

    echo -e "${CYAN}⊝ SKIPPED PACKAGES (0):${NC}"
    echo -e "  ${CYAN}•${NC} None"
    echo ""

    echo -e "${RED}✗ FAILED PACKAGES (0):${NC}"
    echo -e "  ${RED}•${NC} None"
    echo ""

    echo -e "${PURPLE}📊 STATISTICS:${NC}"
    echo -e "  Total packages processed: 12"
    echo -e "  Successfully installed: ${GREEN}12${NC}"
    echo -e "  Skipped: ${CYAN}0${NC}"
    echo -e "  Failed: ${RED}0${NC}"
    echo -e "  Success rate: ${GREEN}100%${NC} 🎉"
    echo ""

    # Demo 7: Benefits
    print_header "7. Key Benefits"
    echo -e "${BLUE}This enhanced system provides several advantages:${NC}"
    echo ""

    echo -e "${GREEN}✅ Personalized Installation${NC}"
    echo -e "  • Users choose exactly what they want"
    echo -e "  • No unnecessary software installed"
    echo -e "  • Faster installation times"
    echo ""

    echo -e "${GREEN}✅ Smart Configuration${NC}"
    echo -e "  • Git configured with user details"
    echo -e "  • NFS setup based on user needs"
    echo -e "  • Development tools only on dev machines"
    echo ""

    echo -e "${GREEN}✅ Better Organization${NC}"
    echo -e "  • Software grouped by logical categories"
    echo -e "  • Clear progress tracking"
    echo -e "  • Comprehensive installation summary"
    echo ""

    echo -e "${GREEN}✅ Enhanced User Experience${NC}"
    echo -e "  • Interactive setup with timeouts"
    echo -e "  • Clear questions with defaults"
    echo -e "  • Auto-continue prevents hanging"
    echo ""

    # Demo 8: How to test
    print_header "8. How to Test This System"
    echo -e "${BLUE}To test the enhanced Debian setup:${NC}"
    echo ""

    echo -e "${CYAN}1. Run the enhanced Debian setup:${NC}"
    echo -e "${PURPLE}   bash -c \"\$(wget --no-cache -qO - https://raw.github.com/brahmatruti/.dotfiles/main/system/debian/setup_packages.sh)\"${NC}"
    echo ""

    echo -e "${CYAN}2. Answer the configuration questions:${NC}"
    echo -e "${PURPLE}   • Enter your git username and email${NC}"
    echo -e "${PURPLE}   • Choose if it's a development machine${NC}"
    echo -e "${PURPLE}   • Select NFS configuration${NC}"
    echo -e "${PURPLE}   • Pick software categories to install${NC}"
    echo ""

    echo -e "${CYAN}3. Watch the categorized installation:${NC}"
    echo -e "${PURPLE}   • See packages grouped by category${NC}"
    echo -e "${PURPLE}   • Only selected categories are installed${NC}"
    echo -e "${PURPLE}   • Git is configured automatically${NC}"
    echo ""

    echo -e "${CYAN}4. Review the installation summary:${NC}"
    echo -e "${PURPLE}   • See what was installed, skipped, or failed${NC}"
    echo -e "${PURPLE}   • Get success rate and recommendations${NC}"
    echo ""

    print_header "Demo Complete"
    echo -e "${GREEN}🎉 The enhanced Debian setup system is ready for testing!${NC}"
    echo ""
    echo -e "${BLUE}This system provides a much better user experience with:${NC}"
    echo -e "${BLUE}• Personalized installations based on user preferences${NC}"
    echo -e "${BLUE}• Organized software categories${NC}"
    echo -e "${BLUE}• Smart configuration and setup${NC}"
    echo -e "${BLUE}• Comprehensive progress tracking${NC}"
    echo -e "${BLUE}• Detailed installation summaries${NC}"
}

#==================================
# Run Demo
#==================================

demo_enhanced_setup

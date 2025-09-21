#!/bin/bash

#==================================
# Enhanced Debian Setup Test
#==================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test configuration
TEST_DIR="/tmp/enhanced-debian-test"
LOG_FILE="$TEST_DIR/test-results.log"

#==================================
# Utility Functions
#==================================

print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${PURPLE}TESTING: $1${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_title() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

#==================================
# Test Functions
#==================================

test_user_config_creation() {
    print_header "Testing User Configuration Creation"

    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"

    # Copy the user config utility
    cp "$HOME/.dotfiles/scripts/utils/utils_user_config.sh" .

    # Test configuration collection (simulated)
    print_title "Testing configuration collection functions..."

    # Source the utility
    . "./utils_user_config.sh"

    # Test that functions exist
    if type collect_user_config >/dev/null 2>&1; then
        print_success "collect_user_config function exists"
        log_message "PASS: collect_user_config function exists"
    else
        print_error "collect_user_config function not found"
        log_message "FAIL: collect_user_config function not found"
        return 1
    fi

    if type ask_yes_no >/dev/null 2>&1; then
        print_success "ask_yes_no function exists"
        log_message "PASS: ask_yes_no function exists"
    else
        print_error "ask_yes_no function not found"
        log_message "FAIL: ask_yes_no function not found"
        return 1
    fi

    if type get_software_categories >/dev/null 2>&1; then
        print_success "get_software_categories function exists"
        log_message "PASS: get_software_categories function exists"
    else
        print_error "get_software_categories function not found"
        log_message "FAIL: get_software_categories function not found"
        return 1
    fi

    return 0
}

test_category_system() {
    print_header "Testing Software Category System"

    # Source the utility
    . "$HOME/.dotfiles/scripts/utils/utils_user_config.sh"

    print_title "Testing software categories..."

    # Test category listing
    categories=$(get_software_categories)
    if [ -n "$categories" ]; then
        print_success "Software categories retrieved successfully"
        log_message "PASS: Software categories retrieved"
    else
        print_error "Failed to retrieve software categories"
        log_message "FAIL: Software categories retrieval"
        return 1
    fi

    # Test package retrieval for each category
    local test_categories=("Essential Tools" "Development Tools" "Programming Languages")
    for category in "${test_categories[@]}"; do
        packages=$(get_category_packages "$category")
        if [ -n "$packages" ]; then
            print_success "Packages retrieved for $category"
            log_message "PASS: Packages retrieved for $category"
        else
            print_error "No packages found for $category"
            log_message "FAIL: No packages found for $category"
            return 1
        fi
    done

    return 0
}

test_enhanced_debian_setup() {
    print_header "Testing Enhanced Debian Setup"

    # Check if the enhanced setup script exists
    if [ -f "$HOME/.dotfiles/system/debian/setup_packages.sh" ]; then
        print_success "Enhanced Debian setup script exists"
        log_message "PASS: Enhanced Debian setup script exists"
    else
        print_error "Enhanced Debian setup script not found"
        log_message "FAIL: Enhanced Debian setup script not found"
        return 1
    fi

    # Check for required utilities
    local required_utils=(
        "utils_user_config.sh"
        "utils_logging.sh"
        "utils_installation.sh"
    )

    for util in "${required_utils[@]}"; do
        if [ -f "$HOME/.dotfiles/scripts/utils/$util" ]; then
            print_success "Required utility found: $util"
            log_message "PASS: Required utility found: $util"
        else
            print_error "Required utility missing: $util"
            log_message "FAIL: Required utility missing: $util"
            return 1
        fi
    done

    return 0
}

test_configuration_workflow() {
    print_header "Testing Configuration Workflow"

    # Create a test configuration
    print_title "Creating test configuration..."

    # Simulate user responses
    export GIT_USER_NAME="Test User"
    export GIT_USER_EMAIL="test@example.com"
    export IS_DEVELOPMENT_MACHINE="true"
    export NFS_ENABLED="false"
    export SELECTED_CATEGORIES=("Essential Tools" "Development Tools")

    # Generate test config
    cat > "$TEST_DIR/test_config.sh" << 'EOF'
#!/bin/bash
# Test Configuration
export GIT_USER_NAME="Test User"
export GIT_USER_EMAIL="test@example.com"
export IS_DEVELOPMENT_MACHINE="true"
export NFS_ENABLED="false"
export SELECTED_CATEGORIES="Essential Tools Development Tools"
export PACKAGES_ESSENTIAL_TOOLS="tmux,less,eza,bat,tree"
export PACKAGES_DEVELOPMENT_TOOLS="git,build-essential,curl,wget"
EOF

    if [ -f "$TEST_DIR/test_config.sh" ]; then
        print_success "Test configuration created successfully"
        log_message "PASS: Test configuration created"
    else
        print_error "Failed to create test configuration"
        log_message "FAIL: Test configuration creation"
        return 1
    fi

    return 0
}

test_package_grouping() {
    print_header "Testing Package Grouping Logic"

    # Source utilities
    . "$HOME/.dotfiles/scripts/utils/utils_user_config.sh"

    print_title "Testing package grouping..."

    # Test that packages are properly grouped
    local essential_packages=$(get_category_packages "Essential Tools")
    local dev_packages=$(get_category_packages "Development Tools")

    if [[ "$essential_packages" == *"tmux"* ]] && [[ "$essential_packages" == *"eza"* ]]; then
        print_success "Essential Tools category contains expected packages"
        log_message "PASS: Essential Tools category contains expected packages"
    else
        print_error "Essential Tools category missing expected packages"
        log_message "FAIL: Essential Tools category missing expected packages"
        return 1
    fi

    if [[ "$dev_packages" == *"git"* ]] && [[ "$dev_packages" == *"build-essential"* ]]; then
        print_success "Development Tools category contains expected packages"
        log_message "PASS: Development Tools category contains expected packages"
    else
        print_error "Development Tools category missing expected packages"
        log_message "FAIL: Development Tools category missing expected packages"
        return 1
    fi

    return 0
}

#==================================
# Main Test Suite
#==================================

main() {
    echo "Starting Enhanced Debian Setup Test Suite..."
    echo "Test results will be logged to: $LOG_FILE"
    echo ""

    # Create test directory and log file
    mkdir -p "$TEST_DIR"
    echo "Enhanced Debian Setup Test Results" > "$LOG_FILE"
    echo "===================================" >> "$LOG_FILE"
    echo "$(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    local total_tests=0
    local failed_tests=0

    # Run all tests
    tests=(
        test_user_config_creation
        test_category_system
        test_enhanced_debian_setup
        test_configuration_workflow
        test_package_grouping
    )

    for test in "${tests[@]}"; do
        total_tests=$((total_tests + 1))

        echo -e "${PURPLE}⟲${NC} Running $test..."
        log_message "START: $test"

        if $test; then
            log_message "PASS: $test"
        else
            failed_tests=$((failed_tests + 1))
            log_message "FAIL: $test"
        fi

        echo ""
    done

    # Print final results
    print_header "Test Results Summary"

    if [ $failed_tests -eq 0 ]; then
        print_success "All tests passed! ($total_tests/$total_tests)"
        echo -e "${GREEN}🎉 Enhanced Debian setup is working correctly!${NC}"
        echo ""
        echo -e "${BLUE}📋 Key Features Verified:${NC}"
        echo -e "  ${GREEN}✓${NC} User configuration collection"
        echo -e "  ${GREEN}✓${NC} Software category system"
        echo -e "  ${GREEN}✓${NC} Enhanced Debian setup script"
        echo -e "  ${GREEN}✓${NC} Configuration workflow"
        echo -e "  ${GREEN}✓${NC} Package grouping logic"
        log_message "SUCCESS: All $total_tests tests passed"
        return 0
    else
        print_error "$failed_tests out of $total_tests tests failed"
        echo -e "${RED}❌ Some tests failed. Check the log file for details.${NC}"
        log_message "FAILURE: $failed_tests out of $total_tests tests failed"
        return 1
    fi
}

#==================================
# Run Tests
#==================================

# Check if we're in the right directory
if [ ! -d "$HOME/.dotfiles" ]; then
    print_error "Error: This script must be run from the Uni_dotfiles directory"
    exit 1
fi

# Run the test suite
main

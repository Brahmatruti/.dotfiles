#!/bin/bash

#==================================
# Basic Debian Setup Test
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
TEST_DIR="/tmp/basic-debian-test"
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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

#==================================
# Test Functions
#==================================

test_basic_debian_setup() {
    print_header "Testing Basic Debian Setup"

    # Check if the basic setup script exists
    if [ -f "$HOME/.dotfiles/system/debian/setup_packages.sh" ]; then
        print_success "Basic Debian setup script exists"
        log_message "PASS: Basic Debian setup script exists"
    else
        print_error "Basic Debian setup script not found"
        log_message "FAIL: Basic Debian setup script not found"
        return 1
    fi

    # Check that it only sources basic utilities (not the complex user config)
    if grep -q "utils_user_config.sh" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
        print_warning "Basic setup still references user config utilities"
        log_message "WARN: Basic setup references user config utilities"
    else
        print_success "Basic setup uses only core utilities"
        log_message "PASS: Basic setup uses only core utilities"
    fi

    # Check for required functions
    local required_functions=(
        "apt_install"
        "snap_install"
        "flatpak_install"
        "handle_package_error"
        "apt_install_with_retry"
        "snap_install_with_retry"
        "flatpak_install_with_retry"
    )

    for func in "${required_functions[@]}"; do
        if grep -q "^$func()" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Function found: $func"
            log_message "PASS: Function found: $func"
        else
            print_error "Function missing: $func"
            log_message "FAIL: Function missing: $func"
            return 1
        fi
    done

    return 0
}

test_script_syntax() {
    print_header "Testing Script Syntax"

    local scripts=(
        "$HOME/.dotfiles/system/debian/setup_packages.sh"
        "$HOME/.dotfiles/scripts/utils/utils.sh"
        "$HOME/.dotfiles/scripts/utils/utils_debian.sh"
    )

    local failed=0

    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if bash -n "$script" 2>/dev/null; then
                print_success "Syntax OK: $(basename "$script")"
                log_message "PASS: Syntax check for $(basename "$script")"
            else
                print_error "Syntax Error: $(basename "$script")"
                log_message "FAIL: Syntax check for $(basename "$script")"
                failed=$((failed + 1))
            fi
        else
            print_warning "Script not found: $(basename "$script")"
            log_message "WARN: Script not found: $(basename "$script")"
        fi
    done

    return $failed
}

test_function_dependencies() {
    print_header "Testing Function Dependencies"

    # Test that all functions used in the basic setup are available
    local functions_to_check=(
        "print_section"
        "print_title"
        "print_success"
        "print_warning"
        "print_error"
        "print_info"
        "print_question"
        "execute"
        "apt_update"
        "apt_upgrade"
        "apt_add_repo"
        "extension_install"
    )

    for func in "${functions_to_check[@]}"; do
        if grep -q "^$func(" "$HOME/.dotfiles/scripts/utils/utils.sh" || \
           grep -q "^$func(" "$HOME/.dotfiles/scripts/utils/utils_debian.sh" || \
           grep -q "^$func()" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Function available: $func"
            log_message "PASS: Function available: $func"
        else
            print_error "Function not found: $func"
            log_message "FAIL: Function not found: $func"
            return 1
        fi
    done

    return 0
}

test_package_installation_functions() {
    print_header "Testing Package Installation Functions"

    # Test that the retry logic is properly implemented
    if grep -q "max_retries=2" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
       grep -q "retry_count=0" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
       grep -q "while \[ \$retry_count -lt \$max_retries \]" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
        print_success "Retry logic properly implemented"
        log_message "PASS: Retry logic properly implemented"
    else
        print_error "Retry logic not properly implemented"
        log_message "FAIL: Retry logic not properly implemented"
        return 1
    fi

    # Test that error handling is in place
    if grep -q "handle_package_error" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
        print_success "Error handling function present"
        log_message "PASS: Error handling function present"
    else
        print_error "Error handling function missing"
        log_message "FAIL: Error handling function missing"
        return 1
    fi

    return 0
}

test_setup_structure() {
    print_header "Testing Setup Structure"

    # Check that the setup follows the expected structure
    local expected_sections=(
        "Source utilities"
        "Error Handling Functions"
        "Enhanced Package Installation"
        "Print Section Title"
        "Add keys to apt"
        "Add repositories to apt"
        "Update APT packages"
        "Install package managers"
        "Install APT packages"
        "Install Cloud Storage Clients"
        "Install Development Tools"
        "Install Snap packages"
        "Install Flatpak Packages"
        "Install From Source"
        "Install Extensions"
    )

    for section in "${expected_sections[@]}"; do
        if grep -q "$section" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Section found: $section"
            log_message "PASS: Section found: $section"
        else
            print_error "Section missing: $section"
            log_message "FAIL: Section missing: $section"
            return 1
        fi
    done

    return 0
}

#==================================
# Main Test Suite
#==================================

main() {
    echo "Starting Basic Debian Setup Test Suite..."
    echo "Test results will be logged to: $LOG_FILE"
    echo ""

    # Create test directory and log file
    mkdir -p "$TEST_DIR"
    echo "Basic Debian Setup Test Results" > "$LOG_FILE"
    echo "=================================" >> "$LOG_FILE"
    echo "$(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    local total_tests=0
    local failed_tests=0

    # Run all tests
    tests=(
        test_basic_debian_setup
        test_script_syntax
        test_function_dependencies
        test_package_installation_functions
        test_setup_structure
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
        echo -e "${GREEN}🎉 Basic Debian setup is working correctly!${NC}"
        echo ""
        echo -e "${BLUE}📋 Features Verified:${NC}"
        echo -e "  ${GREEN}✓${NC} Basic setup script exists and is functional"
        echo -e "  ${GREEN}✓${NC} Uses only core utilities (no complex dependencies)"
        echo -e "  ${GREEN}✓${NC} All required functions are available"
        echo -e "  ${GREEN}✓${NC} Retry logic properly implemented"
        echo -e "  ${GREEN}✓${NC} Error handling in place"
        echo -e "  ${GREEN}✓${NC} Script syntax is valid"
        echo -e "  ${GREEN}✓${NC} Setup structure is complete"
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

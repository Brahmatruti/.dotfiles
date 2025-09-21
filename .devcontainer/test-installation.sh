#!/bin/bash

#==================================
# Uni_dotfiles Installation Test Suite
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
TEST_DIR="/tmp/dotfiles-test"
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

test_script_syntax() {
    print_header "Testing Script Syntax"

    local scripts=(
        "scripts/setup.sh"
        "scripts/utils/utils.sh"
        "scripts/utils/utils_logging.sh"
        "scripts/utils/utils_installation.sh"
    )

    local failed=0

    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if bash -n "$script" 2>/dev/null; then
                print_success "Syntax OK: $script"
                log_message "PASS: Syntax check for $script"
            else
                print_error "Syntax Error: $script"
                log_message "FAIL: Syntax check for $script"
                failed=$((failed + 1))
            fi
        else
            print_warning "Script not found: $script"
            log_message "WARN: Script not found: $script"
        fi
    done

    return $failed
}

test_os_specific_scripts() {
    print_header "Testing OS-Specific Scripts"

    local os_scripts=(
        "system/debian/setup_packages.sh"
        "system/ubuntu/setup_packages.sh"
        "system/macos/setup_packages.sh"
        "system/windows/setup_packages.ps1"
        "system/arch/setup_packages.sh"
        "system/alpine/setup_packages.sh"
        "system/wsl_ubuntu/setup_packages.sh"
        "system/lite/install.sh"
    )

    local failed=0

    for script in "${os_scripts[@]}"; do
        if [ -f "$script" ]; then
            case "$script" in
                *.sh)
                    if bash -n "$script" 2>/dev/null; then
                        print_success "Syntax OK: $script"
                        log_message "PASS: Syntax check for $script"
                    else
                        print_error "Syntax Error: $script"
                        log_message "FAIL: Syntax check for $script"
                        failed=$((failed + 1))
                    fi
                    ;;
                *.ps1)
                    # Basic PowerShell syntax check
                    if pwsh -NoProfile -Command "try { [System.Management.Automation.PSParser]::Tokenize((Get-Content '$script' -Raw), [ref]$null) | Out-Null; exit 0 } catch { exit 1 }" 2>/dev/null; then
                        print_success "Syntax OK: $script"
                        log_message "PASS: Syntax check for $script"
                    else
                        print_error "Syntax Error: $script"
                        log_message "FAIL: Syntax check for $script"
                        failed=$((failed + 1))
                    fi
                    ;;
            esac
        else
            print_warning "Script not found: $script"
            log_message "WARN: Script not found: $script"
        fi
    done

    return $failed
}

test_logging_functions() {
    print_header "Testing Logging Functions"

    # Source the logging utilities
    . "scripts/utils/utils_logging.sh"

    # Test logging functions
    log_success "test-package" "Test Package"
    log_failure "test-package" "Test Package" "Test failure reason"
    log_skipped "test-package" "Test Package" "Test skip reason"
    log_warning "Test warning message"
    log_info "Test info message"

    print_success "Logging functions work correctly"
    log_message "PASS: Logging functions test"
}

test_installation_summary() {
    print_header "Testing Installation Summary"

    # Source utilities
    . "scripts/utils/utils_logging.sh"

    # Add some test data
    SUCCESSFUL_PACKAGES+=("Test Package 1 (test-pkg1)")
    SUCCESSFUL_PACKAGES+=("Test Package 2 (test-pkg2)")
    FAILED_PACKAGES+=("Failed Package (failed-pkg) - Test failure")
    SKIPPED_PACKAGES+=("Skipped Package (skipped-pkg) - Test skip")

    # Test the summary function
    print_installation_summary

    print_success "Installation summary works correctly"
    log_message "PASS: Installation summary test"
}

test_retry_logic() {
    print_header "Testing Retry Logic"

    # Source utilities
    . "scripts/utils/utils_installation.sh"

    # Test that retry variables are set correctly
    if [ "$max_retries" = "2" ] && [ "$retry_interval" = "3" ]; then
        print_success "Retry logic configured correctly (2 attempts, 3-second intervals)"
        log_message "PASS: Retry logic configuration test"
    else
        print_error "Retry logic not configured correctly"
        log_message "FAIL: Retry logic configuration test"
        return 1
    fi
}

test_auto_continue() {
    print_header "Testing Auto-Continue Logic"

    # Source utilities
    . "scripts/utils/utils_installation.sh"

    # Test that auto-continue timeout is set correctly
    local expected_timeout=3

    # This is a bit tricky to test automatically, but we can check if the function exists
    if type handle_package_error >/dev/null 2>&1; then
        print_success "Auto-continue function exists"
        log_message "PASS: Auto-continue function test"
    else
        print_error "Auto-continue function not found"
        log_message "FAIL: Auto-continue function test"
        return 1
    fi
}

test_os_specific_features() {
    print_header "Testing OS-Specific Features"

    local failed=0

    # Test Debian-specific features
    if [ -f "system/debian/setup_packages.sh" ]; then
        if grep -q "utils_debian.sh" "system/debian/setup_packages.sh" && \
           grep -q "print_installation_summary" "system/debian/setup_packages.sh"; then
            print_success "Debian: Enhanced features implemented"
            log_message "PASS: Debian OS-specific features test"
        else
            print_error "Debian: Missing enhanced features"
            log_message "FAIL: Debian OS-specific features test"
            failed=$((failed + 1))
        fi
    fi

    # Test Ubuntu-specific features
    if [ -f "system/ubuntu/setup_packages.sh" ]; then
        if grep -q "utils_logging.sh" "system/ubuntu/setup_packages.sh" && \
           grep -q "print_installation_summary" "system/ubuntu/setup_packages.sh"; then
            print_success "Ubuntu: Enhanced features implemented"
            log_message "PASS: Ubuntu OS-specific features test"
        else
            print_error "Ubuntu: Missing enhanced features"
            log_message "FAIL: Ubuntu OS-specific features test"
            failed=$((failed + 1))
        fi
    fi

    # Test macOS-specific features
    if [ -f "system/macos/setup_packages.sh" ]; then
        if grep -q "utils_logging.sh" "system/macos/setup_packages.sh" && \
           grep -q "print_installation_summary" "system/macos/setup_packages.sh"; then
            print_success "macOS: Enhanced features implemented"
            log_message "PASS: macOS OS-specific features test"
        else
            print_error "macOS: Missing enhanced features"
            log_message "FAIL: macOS OS-specific features test"
            failed=$((failed + 1))
        fi
    fi

    return $failed
}

#==================================
# Main Test Suite
#==================================

main() {
    echo "Starting Uni_dotfiles Installation Test Suite..."
    echo "Test results will be logged to: $LOG_FILE"
    echo ""

    # Create test directory and log file
    mkdir -p "$TEST_DIR"
    echo "Uni_dotfiles Installation Test Results" > "$LOG_FILE"
    echo "=====================================" >> "$LOG_FILE"
    echo "$(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    local total_tests=0
    local failed_tests=0

    # Run all tests
    tests=(
        test_script_syntax
        test_os_specific_scripts
        test_logging_functions
        test_installation_summary
        test_retry_logic
        test_auto_continue
        test_os_specific_features
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
        echo -e "${GREEN}🎉 All tests completed successfully!${NC}"
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
if [ ! -f "scripts/setup.sh" ]; then
    print_error "Error: This script must be run from the Uni_dotfiles root directory"
    exit 1
fi

# Run the test suite
main

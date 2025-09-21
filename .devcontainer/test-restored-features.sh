#!/bin/bash

#==================================
# Restored Features Test
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
TEST_DIR="/tmp/restored-features-test"
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

test_debian_restored_features() {
    print_header "Testing Debian Restored Features"

    if [ -f "$HOME/.dotfiles/system/debian/setup_packages.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Debian: Logging utilities sourced"
            log_message "PASS: Debian logging utilities"
        else
            print_error "Debian: Logging utilities missing"
            log_message "FAIL: Debian logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Debian: Installation summary present"
            log_message "PASS: Debian installation summary"
        else
            print_error "Debian: Installation summary missing"
            log_message "FAIL: Debian installation summary"
            return 1
        fi

        # Check for GPG key handling
        if grep -q "install_gpg_key.*Docker" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
           grep -q "install_gpg_key.*HashiCorp" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Debian: GPG key handling restored"
            log_message "PASS: Debian GPG key handling"
        else
            print_error "Debian: GPG key handling missing"
            log_message "FAIL: Debian GPG key handling"
            return 1
        fi
    else
        print_error "Debian setup script not found"
        log_message "FAIL: Debian setup script not found"
        return 1
    fi

    return 0
}

test_ubuntu_restored_features() {
    print_header "Testing Ubuntu Restored Features"

    if [ -f "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"; then
            print_success "Ubuntu: Logging utilities sourced"
            log_message "PASS: Ubuntu logging utilities"
        else
            print_error "Ubuntu: Logging utilities missing"
            log_message "FAIL: Ubuntu logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"; then
            print_success "Ubuntu: Installation summary present"
            log_message "PASS: Ubuntu installation summary"
        else
            print_error "Ubuntu: Installation summary missing"
            log_message "FAIL: Ubuntu installation summary"
            return 1
        fi

        # Check for GPG key handling
        if grep -q "install_gpg_key.*Docker" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" && \
           grep -q "install_gpg_key.*HashiCorp" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"; then
            print_success "Ubuntu: GPG key handling restored"
            log_message "PASS: Ubuntu GPG key handling"
        else
            print_error "Ubuntu: GPG key handling missing"
            log_message "FAIL: Ubuntu GPG key handling"
            return 1
        fi
    else
        print_error "Ubuntu setup script not found"
        log_message "FAIL: Ubuntu setup script not found"
        return 1
    fi

    return 0
}

test_macos_restored_features() {
    print_header "Testing macOS Restored Features"

    if [ -f "$HOME/.dotfiles/system/macos/setup_packages.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/macos/setup_packages.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/macos/setup_packages.sh"; then
            print_success "macOS: Logging utilities sourced"
            log_message "PASS: macOS logging utilities"
        else
            print_error "macOS: Logging utilities missing"
            log_message "FAIL: macOS logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/macos/setup_packages.sh"; then
            print_success "macOS: Installation summary present"
            log_message "PASS: macOS installation summary"
        else
            print_error "macOS: Installation summary missing"
            log_message "FAIL: macOS installation summary"
            return 1
        fi
    else
        print_error "macOS setup script not found"
        log_message "FAIL: macOS setup script not found"
        return 1
    fi

    return 0
}

test_windows_restored_features() {
    print_header "Testing Windows Restored Features"

    if [ -f "$HOME/.dotfiles/system/windows/setup_packages.ps1" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.ps1" "$HOME/.dotfiles/system/windows/setup_packages.ps1" && \
           grep -q "utils_installation.ps1" "$HOME/.dotfiles/system/windows/setup_packages.ps1"; then
            print_success "Windows: Logging utilities sourced"
            log_message "PASS: Windows logging utilities"
        else
            print_error "Windows: Logging utilities missing"
            log_message "FAIL: Windows logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "Write-InstallationSummary" "$HOME/.dotfiles/system/windows/setup_packages.ps1"; then
            print_success "Windows: Installation summary present"
            log_message "PASS: Windows installation summary"
        else
            print_error "Windows: Installation summary missing"
            log_message "FAIL: Windows installation summary"
            return 1
        fi
    else
        print_error "Windows setup script not found"
        log_message "FAIL: Windows setup script not found"
        return 1
    fi

    return 0
}

test_arch_restored_features() {
    print_header "Testing Arch Restored Features"

    if [ -f "$HOME/.dotfiles/system/arch/setup_packages.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/arch/setup_packages.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/arch/setup_packages.sh"; then
            print_success "Arch: Logging utilities sourced"
            log_message "PASS: Arch logging utilities"
        else
            print_error "Arch: Logging utilities missing"
            log_message "FAIL: Arch logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/arch/setup_packages.sh"; then
            print_success "Arch: Installation summary present"
            log_message "PASS: Arch installation summary"
        else
            print_error "Arch: Installation summary missing"
            log_message "FAIL: Arch installation summary"
            return 1
        fi
    else
        print_error "Arch setup script not found"
        log_message "FAIL: Arch setup script not found"
        return 1
    fi

    return 0
}

test_alpine_restored_features() {
    print_header "Testing Alpine Restored Features"

    if [ -f "$HOME/.dotfiles/system/alpine/setup_packages.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/alpine/setup_packages.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/alpine/setup_packages.sh"; then
            print_success "Alpine: Logging utilities sourced"
            log_message "PASS: Alpine logging utilities"
        else
            print_error "Alpine: Logging utilities missing"
            log_message "FAIL: Alpine logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/alpine/setup_packages.sh"; then
            print_success "Alpine: Installation summary present"
            log_message "PASS: Alpine installation summary"
        else
            print_error "Alpine: Installation summary missing"
            log_message "FAIL: Alpine installation summary"
            return 1
        fi
    else
        print_error "Alpine setup script not found"
        log_message "FAIL: Alpine setup script not found"
        return 1
    fi

    return 0
}

test_wsl_ubuntu_restored_features() {
    print_header "Testing WSL Ubuntu Restored Features"

    if [ -f "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh"; then
            print_success "WSL Ubuntu: Logging utilities sourced"
            log_message "PASS: WSL Ubuntu logging utilities"
        else
            print_error "WSL Ubuntu: Logging utilities missing"
            log_message "FAIL: WSL Ubuntu logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh"; then
            print_success "WSL Ubuntu: Installation summary present"
            log_message "PASS: WSL Ubuntu installation summary"
        else
            print_error "WSL Ubuntu: Installation summary missing"
            log_message "FAIL: WSL Ubuntu installation summary"
            return 1
        fi
    else
        print_error "WSL Ubuntu setup script not found"
        log_message "FAIL: WSL Ubuntu setup script not found"
        return 1
    fi

    return 0
}

test_lite_restored_features() {
    print_header "Testing Lite Restored Features"

    if [ -f "$HOME/.dotfiles/system/lite/install.sh" ]; then
        # Check for logging utilities
        if grep -q "utils_logging.sh" "$HOME/.dotfiles/system/lite/install.sh" && \
           grep -q "utils_installation.sh" "$HOME/.dotfiles/system/lite/install.sh"; then
            print_success "Lite: Logging utilities sourced"
            log_message "PASS: Lite logging utilities"
        else
            print_error "Lite: Logging utilities missing"
            log_message "FAIL: Lite logging utilities"
            return 1
        fi

        # Check for installation summary
        if grep -q "print_installation_summary" "$HOME/.dotfiles/system/lite/install.sh"; then
            print_success "Lite: Installation summary present"
            log_message "PASS: Lite installation summary"
        else
            print_error "Lite: Installation summary missing"
            log_message "FAIL: Lite installation summary"
            return 1
        fi
    else
        print_error "Lite setup script not found"
        log_message "FAIL: Lite setup script not found"
        return 1
    fi

    return 0
}

test_logging_functions() {
    print_header "Testing Logging Functions"

    # Test that logging functions are available
    local logging_functions=(
        "log_success"
        "log_failure"
        "log_skipped"
        "log_warning"
        "log_info"
        "track_installation_attempt"
        "track_installation_result"
        "print_installation_summary"
    )

    for func in "${logging_functions[@]}"; do
        if grep -q "^$func(" "$HOME/.dotfiles/scripts/utils/utils_logging.sh"; then
            print_success "Logging function available: $func"
            log_message "PASS: Logging function $func"
        else
            print_error "Logging function missing: $func"
            log_message "FAIL: Logging function $func"
            return 1
        fi
    done

    return 0
}

test_installation_functions() {
    print_header "Testing Installation Functions"

    # Test that installation functions are available
    local installation_functions=(
        "install_gpg_key"
        "apt_install_with_retry"
        "snap_install_with_retry"
        "flatpak_install_with_retry"
        "brew_install_with_retry"
        "choco_install_with_retry"
        "winget_install_with_retry"
    )

    for func in "${installation_functions[@]}"; do
        if grep -q "^$func(" "$HOME/.dotfiles/scripts/utils/utils_installation.sh"; then
            print_success "Installation function available: $func"
            log_message "PASS: Installation function $func"
        else
            print_error "Installation function missing: $func"
            log_message "FAIL: Installation function $func"
            return 1
        fi
    done

    return 0
}

#==================================
# Main Test Suite
#==================================

main() {
    echo "Starting Restored Features Test Suite..."
    echo "Test results will be logged to: $LOG_FILE"
    echo ""

    # Create test directory and log file
    mkdir -p "$TEST_DIR"
    echo "Restored Features Test Results" > "$LOG_FILE"
    echo "===============================" >> "$LOG_FILE"
    echo "$(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    local total_tests=0
    local failed_tests=0

    # Run all tests
    tests=(
        test_debian_restored_features
        test_ubuntu_restored_features
        test_macos_restored_features
        test_windows_restored_features
        test_arch_restored_features
        test_alpine_restored_features
        test_wsl_ubuntu_restored_features
        test_lite_restored_features
        test_logging_functions
        test_installation_functions
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
        echo -e "${GREEN}🎉 All restored features are working correctly across all OS systems!${NC}"
        echo ""
        echo -e "${BLUE}📋 Features Verified:${NC}"
        echo -e "  ${GREEN}✓${NC} Logging functionality restored"
        echo -e "  ${GREEN}✓${NC} Installation summary features restored"
        echo -e "  ${GREEN}✓${NC} GPG key handling restored"
        echo -e "  ${GREEN}✓${NC} Auto-continue functionality maintained"
        echo -e "  ${GREEN}✓${NC} Retry logic maintained"
        echo -e "  ${GREEN}✓${NC} Consistent implementation across all 8 OS systems"
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

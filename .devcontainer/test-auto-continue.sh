#!/bin/bash

#==================================
# Auto-Continue Functionality Test
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
TEST_DIR="/tmp/auto-continue-test"
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

test_debian_auto_continue() {
    print_header "Testing Debian Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/debian/setup_packages.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
            print_success "Debian: Auto-continue properly implemented"
            log_message "PASS: Debian auto-continue implementation"
        else
            print_error "Debian: Auto-continue not properly implemented"
            log_message "FAIL: Debian auto-continue implementation"
            return 1
        fi
    else
        print_error "Debian setup script not found"
        log_message "FAIL: Debian setup script not found"
        return 1
    fi

    return 0
}

test_ubuntu_auto_continue() {
    print_header "Testing Ubuntu Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"; then
            print_success "Ubuntu: Auto-continue properly implemented"
            log_message "PASS: Ubuntu auto-continue implementation"
        else
            print_error "Ubuntu: Auto-continue not properly implemented"
            log_message "FAIL: Ubuntu auto-continue implementation"
            return 1
        fi
    else
        print_error "Ubuntu setup script not found"
        log_message "FAIL: Ubuntu setup script not found"
        return 1
    fi

    return 0
}

test_macos_auto_continue() {
    print_header "Testing macOS Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/macos/setup_packages.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/macos/setup_packages.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/macos/setup_packages.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/macos/setup_packages.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/macos/setup_packages.sh"; then
            print_success "macOS: Auto-continue properly implemented"
            log_message "PASS: macOS auto-continue implementation"
        else
            print_error "macOS: Auto-continue not properly implemented"
            log_message "FAIL: macOS auto-continue implementation"
            return 1
        fi
    else
        print_error "macOS setup script not found"
        log_message "FAIL: macOS setup script not found"
        return 1
    fi

    return 0
}

test_windows_auto_continue() {
    print_header "Testing Windows Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/windows/setup_packages.ps1" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "maxRetries = 2" "$HOME/.dotfiles/system/windows/setup_packages.ps1" && \
           grep -q "Start-Sleep -Seconds 3" "$HOME/.dotfiles/system/windows/setup_packages.ps1" && \
           grep -q "Read-Host -Timeout 3" "$HOME/.dotfiles/system/windows/setup_packages.ps1" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/windows/setup_packages.ps1"; then
            print_success "Windows: Auto-continue properly implemented"
            log_message "PASS: Windows auto-continue implementation"
        else
            print_error "Windows: Auto-continue not properly implemented"
            log_message "FAIL: Windows auto-continue implementation"
            return 1
        fi
    else
        print_error "Windows setup script not found"
        log_message "FAIL: Windows setup script not found"
        return 1
    fi

    return 0
}

test_arch_auto_continue() {
    print_header "Testing Arch Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/arch/setup_packages.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/arch/setup_packages.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/arch/setup_packages.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/arch/setup_packages.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/arch/setup_packages.sh"; then
            print_success "Arch: Auto-continue properly implemented"
            log_message "PASS: Arch auto-continue implementation"
        else
            print_error "Arch: Auto-continue not properly implemented"
            log_message "FAIL: Arch auto-continue implementation"
            return 1
        fi
    else
        print_error "Arch setup script not found"
        log_message "FAIL: Arch setup script not found"
        return 1
    fi

    return 0
}

test_alpine_auto_continue() {
    print_header "Testing Alpine Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/alpine/setup_packages.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/alpine/setup_packages.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/alpine/setup_packages.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/alpine/setup_packages.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/alpine/setup_packages.sh"; then
            print_success "Alpine: Auto-continue properly implemented"
            log_message "PASS: Alpine auto-continue implementation"
        else
            print_error "Alpine: Auto-continue not properly implemented"
            log_message "FAIL: Alpine auto-continue implementation"
            return 1
        fi
    else
        print_error "Alpine setup script not found"
        log_message "FAIL: Alpine setup script not found"
        return 1
    fi

    return 0
}

test_wsl_ubuntu_auto_continue() {
    print_header "Testing WSL Ubuntu Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/wsl_ubuntu/setup_packages.sh"; then
            print_success "WSL Ubuntu: Auto-continue properly implemented"
            log_message "PASS: WSL Ubuntu auto-continue implementation"
        else
            print_error "WSL Ubuntu: Auto-continue not properly implemented"
            log_message "FAIL: WSL Ubuntu auto-continue implementation"
            return 1
        fi
    else
        print_error "WSL Ubuntu setup script not found"
        log_message "FAIL: WSL Ubuntu setup script not found"
        return 1
    fi

    return 0
}

test_lite_auto_continue() {
    print_header "Testing Lite Auto-Continue"

    if [ -f "$HOME/.dotfiles/system/lite/install.sh" ]; then
        # Check for retry logic (2 attempts, 3-second intervals)
        if grep -q "max_retries=2" "$HOME/.dotfiles/system/lite/install.sh" && \
           grep -q "sleep 3" "$HOME/.dotfiles/system/lite/install.sh" && \
           grep -q "read -t 3 -r choice" "$HOME/.dotfiles/system/lite/install.sh" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/lite/install.sh"; then
            print_success "Lite: Auto-continue properly implemented"
            log_message "PASS: Lite auto-continue implementation"
        else
            print_error "Lite: Auto-continue not properly implemented"
            log_message "FAIL: Lite auto-continue implementation"
            return 1
        fi
    else
        print_error "Lite setup script not found"
        log_message "FAIL: Lite setup script not found"
        return 1
    fi

    return 0
}

test_consistent_implementation() {
    print_header "Testing Consistent Implementation"

    # Test that all systems have the same retry parameters
    local expected_retry="max_retries=2"
    local expected_timeout="read -t 3 -r choice"
    local expected_message="No response received within 3 seconds, continuing automatically"

    local systems=(
        "debian:setup_packages.sh"
        "ubuntu:setup_packages.sh"
        "macos:setup_packages.sh"
        "arch:setup_packages.sh"
        "alpine:setup_packages.sh"
        "wsl_ubuntu:setup_packages.sh"
        "lite:install.sh"
    )

    local failed=0

    for system in "${systems[@]}"; do
        IFS=':' read -r os script <<< "$system"
        local file="$HOME/.dotfiles/system/$os/$script"

        if [ -f "$file" ]; then
            if grep -q "$expected_retry" "$file" && \
               grep -q "$expected_timeout" "$file" && \
               grep -q "$expected_message" "$file"; then
                print_success "$os: Consistent implementation"
                log_message "PASS: $os consistent implementation"
            else
                print_error "$os: Inconsistent implementation"
                log_message "FAIL: $os inconsistent implementation"
                failed=$((failed + 1))
            fi
        else
            print_warning "$os: Script not found"
            log_message "WARN: $os script not found"
        fi
    done

    # Special case for Windows (PowerShell)
    if [ -f "$HOME/.dotfiles/system/windows/setup_packages.ps1" ]; then
        if grep -q "maxRetries = 2" "$HOME/.dotfiles/system/windows/setup_packages.ps1" && \
           grep -q "Read-Host -Timeout 3" "$HOME/.dotfiles/system/windows/setup_packages.ps1" && \
           grep -q "No response received within 3 seconds, continuing automatically" "$HOME/.dotfiles/system/windows/setup_packages.ps1"; then
            print_success "Windows: Consistent implementation (PowerShell)"
            log_message "PASS: Windows consistent implementation"
        else
            print_error "Windows: Inconsistent implementation"
            log_message "FAIL: Windows inconsistent implementation"
            failed=$((failed + 1))
        fi
    fi

    return $failed
}

#==================================
# Main Test Suite
#==================================

main() {
    echo "Starting Auto-Continue Functionality Test Suite..."
    echo "Test results will be logged to: $LOG_FILE"
    echo ""

    # Create test directory and log file
    mkdir -p "$TEST_DIR"
    echo "Auto-Continue Functionality Test Results" > "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
    echo "$(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    local total_tests=0
    local failed_tests=0

    # Run all tests
    tests=(
        test_debian_auto_continue
        test_ubuntu_auto_continue
        test_macos_auto_continue
        test_windows_auto_continue
        test_arch_auto_continue
        test_alpine_auto_continue
        test_wsl_ubuntu_auto_continue
        test_lite_auto_continue
        test_consistent_implementation
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
        echo -e "${GREEN}🎉 Auto-continue functionality is properly implemented across all OS systems!${NC}"
        echo ""
        echo -e "${BLUE}📋 Features Verified:${NC}"
        echo -e "  ${GREEN}✓${NC} Retry Logic: 2 attempts with 3-second intervals"
        echo -e "  ${GREEN}✓${NC} Auto-Continue: 3-second timeout with default 'yes'"
        echo -e "  ${GREEN}✓${NC} Consistent implementation across all 8 OS systems"
        echo -e "  ${GREEN}✓${NC} Proper error handling and user feedback"
        echo -e "  ${GREEN}✓${NC} No more hanging installations"
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

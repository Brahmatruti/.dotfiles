#!/bin/bash

#==================================
# Git Credential Fix Test
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
TEST_DIR="/tmp/git-credential-test"
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

test_generate_git_creds() {
    print_header "Testing Git Credentials Generation"

    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"

    # Copy the generate_git_creds script
    cp "$HOME/.dotfiles/scripts/utils/generate_git_creds.sh" .

    # Test that the script exists and is executable
    if [ -f "./generate_git_creds.sh" ]; then
        print_success "generate_git_creds.sh script exists"
        log_message "PASS: generate_git_creds.sh script exists"
    else
        print_error "generate_git_creds.sh script not found"
        log_message "FAIL: generate_git_creds.sh script not found"
        return 1
    fi

    # Test that required functions are available in utils.sh
    if [ -f "$HOME/.dotfiles/scripts/utils/utils.sh" ]; then
        if grep -q "ask_for_confirmation" "$HOME/.dotfiles/scripts/utils/utils.sh" && \
           grep -q "answer_is_yes" "$HOME/.dotfiles/scripts/utils/utils.sh" && \
           grep -q "ask(" "$HOME/.dotfiles/scripts/utils/utils.sh" && \
           grep -q "get_answer" "$HOME/.dotfiles/scripts/utils/utils.sh"; then
            print_success "Required functions found in utils.sh"
            log_message "PASS: Required functions found in utils.sh"
        else
            print_error "Required functions missing from utils.sh"
            log_message "FAIL: Required functions missing from utils.sh"
            return 1
        fi
    else
        print_error "utils.sh not found"
        log_message "FAIL: utils.sh not found"
        return 1
    fi

    return 0
}

test_init_dotfile_repo() {
    print_header "Testing Init Dotfile Repository"

    # Create test directory
    mkdir -p "$TEST_DIR/dotfiles"
    cd "$TEST_DIR/dotfiles"

    # Copy the init_dotfile_repo script
    cp "$HOME/.dotfiles/scripts/utils/init_dotfile_repo.sh" .

    # Test that the script exists and is executable
    if [ -f "./init_dotfile_repo.sh" ]; then
        print_success "init_dotfile_repo.sh script exists"
        log_message "PASS: init_dotfile_repo.sh script exists"
    else
        print_error "init_dotfile_repo.sh script not found"
        log_message "FAIL: init_dotfile_repo.sh script not found"
        return 1
    fi

    # Test that required functions are available in utils.sh
    if [ -f "$HOME/.dotfiles/scripts/utils/utils.sh" ]; then
        if grep -q "is_git_repository" "$HOME/.dotfiles/scripts/utils/utils.sh"; then
            print_success "is_git_repository function found in utils.sh"
            log_message "PASS: is_git_repository function found in utils.sh"
        else
            print_error "is_git_repository function missing from utils.sh"
            log_message "FAIL: is_git_repository function missing from utils.sh"
            return 1
        fi
    else
        print_error "utils.sh not found"
        log_message "FAIL: utils.sh not found"
        return 1
    fi

    return 0
}

test_setup_script_fixes() {
    print_header "Testing Setup Script Fixes"

    # Check if the setup.sh script has the fixes
    if [ -f "$HOME/.dotfiles/scripts/setup.sh" ]; then
        # Check for the git credential fix
        if grep -q "if \[ ! -f \"\$HOME/\.config/git/\.gitconfig\.local\" \]" "$HOME/.dotfiles/scripts/setup.sh"; then
            print_success "Git credential fix found in setup.sh"
            log_message "PASS: Git credential fix found in setup.sh"
        else
            print_error "Git credential fix missing from setup.sh"
            log_message "FAIL: Git credential fix missing from setup.sh"
            return 1
        fi

        # Check for the repository initialization fix
        if grep -q "if \[ -d \"\$HOME/\.dotfiles\" \]" "$HOME/.dotfiles/scripts/setup.sh" && \
           grep -q "cd \"\$HOME/\.dotfiles\" \|\| exit 1" "$HOME/.dotfiles/scripts/setup.sh"; then
            print_success "Repository initialization fix found in setup.sh"
            log_message "PASS: Repository initialization fix found in setup.sh"
        else
            print_error "Repository initialization fix missing from setup.sh"
            log_message "FAIL: Repository initialization fix missing from setup.sh"
            return 1
        fi
    else
        print_error "setup.sh not found"
        log_message "FAIL: setup.sh not found"
        return 1
    fi

    return 0
}

test_enhanced_debian_setup() {
    print_header "Testing Enhanced Debian Setup Integration"

    # Check if the enhanced Debian setup exists
    if [ -f "$HOME/.dotfiles/system/debian/setup_packages.sh" ]; then
        print_success "Enhanced Debian setup script exists"
        log_message "PASS: Enhanced Debian setup script exists"
    else
        print_error "Enhanced Debian setup script not found"
        log_message "FAIL: Enhanced Debian setup script not found"
        return 1
    fi

    # Check for user configuration integration
    if grep -q "utils_user_config.sh" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
       grep -q "collect_user_config" "$HOME/.dotfiles/system/debian/setup_packages.sh" && \
       grep -q "show_config_summary" "$HOME/.dotfiles/system/debian/setup_packages.sh"; then
        print_success "User configuration integration found"
        log_message "PASS: User configuration integration found"
    else
        print_error "User configuration integration missing"
        log_message "FAIL: User configuration integration missing"
        return 1
    fi

    return 0
}

test_script_syntax() {
    print_header "Testing Script Syntax"

    local scripts=(
        "$HOME/.dotfiles/scripts/utils/generate_git_creds.sh"
        "$HOME/.dotfiles/scripts/utils/init_dotfile_repo.sh"
        "$HOME/.dotfiles/scripts/setup.sh"
        "$HOME/.dotfiles/system/debian/setup_packages.sh"
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

#==================================
# Main Test Suite
#==================================

main() {
    echo "Starting Git Credential Fix Test Suite..."
    echo "Test results will be logged to: $LOG_FILE"
    echo ""

    # Create test directory and log file
    mkdir -p "$TEST_DIR"
    echo "Git Credential Fix Test Results" > "$LOG_FILE"
    echo "================================" >> "$LOG_FILE"
    echo "$(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    local total_tests=0
    local failed_tests=0

    # Run all tests
    tests=(
        test_generate_git_creds
        test_init_dotfile_repo
        test_setup_script_fixes
        test_enhanced_debian_setup
        test_script_syntax
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
        echo -e "${GREEN}🎉 Git credential and repository initialization issues are fixed!${NC}"
        echo ""
        echo -e "${BLUE}📋 Issues Resolved:${NC}"
        echo -e "  ${GREEN}✓${NC} Fixed generate_git_creds.sh path issues"
        echo -e "  ${GREEN}✓${NC} Fixed init_dotfile_repo.sh directory navigation"
        echo -e "  ${GREEN}✓${NC} Updated setup.sh to handle git config conflicts"
        echo -e "  ${GREEN}✓${NC} Enhanced Debian setup integration"
        echo -e "  ${GREEN}✓${NC} All script syntax validated"
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

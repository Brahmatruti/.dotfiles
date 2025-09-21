#!/bin/bash

#==================================
# LOGGING UTILITIES
#==================================

# Global arrays to track installation results
declare -a SUCCESSFUL_PACKAGES=()
declare -a FAILED_PACKAGES=()
declare -a SKIPPED_PACKAGES=()

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#==================================
# Logging Functions
#==================================

log_success() {
    local package="$1"
    local description="$2"
    SUCCESSFUL_PACKAGES+=("$description ($package)")
    printf "${GREEN}✓${NC} %s\n" "$description"
}

log_failure() {
    local package="$1"
    local description="$2"
    local reason="$3"
    FAILED_PACKAGES+=("$description ($package) - $reason")
    printf "${RED}✗${NC} %s - ${YELLOW}%s${NC}\n" "$description" "$reason"
}

log_skipped() {
    local package="$1"
    local description="$2"
    local reason="$3"
    SKIPPED_PACKAGES+=("$description ($package) - $reason")
    printf "${CYAN}⊝${NC} %s - ${BLUE}%s${NC}\n" "$description" "$reason"
}

log_warning() {
    local message="$1"
    printf "${YELLOW}⚠${NC} %s\n" "$message"
}

log_info() {
    local message="$1"
    printf "${BLUE}ℹ${NC} %s\n" "$message"
}

#==================================
# Installation Result Tracking
#==================================

track_installation_attempt() {
    local description="$1"
    local package="$2"
    printf "${PURPLE}⟲${NC} Installing %s...\n" "$description"
}

track_installation_result() {
    local success="$1"
    local description="$2"
    local package="$3"
    local reason="${4:-Unknown error}"

    if [ "$success" = "true" ]; then
        log_success "$package" "$description"
    else
        log_failure "$package" "$description" "$reason"
    fi
}

#==================================
# Summary Reports
#==================================

print_installation_summary() {
    local total_packages=$(( ${#SUCCESSFUL_PACKAGES[@]} + ${#FAILED_PACKAGES[@]} + ${#SKIPPED_PACKAGES[@]} ))

    printf "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${CYAN}║${NC}                    ${PURPLE}INSTALLATION SUMMARY${NC}                     ${CYAN}║${NC}\n"
    printf "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}\n\n"

    # Successful packages
    if [ ${#SUCCESSFUL_PACKAGES[@]} -gt 0 ]; then
        printf "${GREEN}✓ SUCCESSFUL PACKAGES (${#SUCCESSFUL_PACKAGES[@]}):${NC}\n"
        for package in "${SUCCESSFUL_PACKAGES[@]}"; do
            printf "  ${GREEN}•${NC} %s\n" "$package"
        done
        printf "\n"
    fi

    # Skipped packages
    if [ ${#SKIPPED_PACKAGES[@]} -gt 0 ]; then
        printf "${CYAN}⊝ SKIPPED PACKAGES (${#SKIPPED_PACKAGES[@]}):${NC}\n"
        for package in "${SKIPPED_PACKAGES[@]}"; do
            printf "  ${CYAN}•${NC} %s\n" "$package"
        done
        printf "\n"
    fi

    # Failed packages
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        printf "${RED}✗ FAILED PACKAGES (${#FAILED_PACKAGES[@]}):${NC}\n"
        for package in "${FAILED_PACKAGES[@]}"; do
            printf "  ${RED}•${NC} %s\n" "$package"
        done
        printf "\n"
    fi

    # Summary statistics
    printf "${PURPLE}📊 STATISTICS:${NC}\n"
    printf "  Total packages processed: %d\n" "$total_packages"
    printf "  Successfully installed: ${GREEN}%d${NC}\n" "${#SUCCESSFUL_PACKAGES[@]}"
    printf "  Skipped: ${CYAN}%d${NC}\n" "${#SKIPPED_PACKAGES[@]}"
    printf "  Failed: ${RED}%d${NC}\n" "${#FAILED_PACKAGES[@]}"

    local success_rate=$(( total_packages > 0 ? ${#SUCCESSFUL_PACKAGES[@]} * 100 / total_packages : 0 ))
    if [ $success_rate -ge 80 ]; then
        printf "  Success rate: ${GREEN}%d%%${NC} 🎉\n" "$success_rate"
    elif [ $success_rate -ge 60 ]; then
        printf "  Success rate: ${YELLOW}%d%%${NC} ⚠️\n" "$success_rate"
    else
        printf "  Success rate: ${RED}%d%%${NC} ❌\n" "$success_rate"
    fi

    printf "\n"

    # Recommendations
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        printf "${YELLOW}💡 RECOMMENDATIONS:${NC}\n"
        printf "  • Review the failed packages list above\n"
        printf "  • Check your internet connection\n"
        printf "  • Verify package names for your OS/distribution\n"
        printf "  • Try installing failed packages manually\n"
        printf "  • Check if repositories are properly configured\n"
        printf "\n"
    fi
}

#==================================
# Export Functions
#==================================

# Make functions available to other scripts
export -f log_success
export -f log_failure
export -f log_skipped
export -f log_warning
export -f log_info
export -f track_installation_attempt
export -f track_installation_result
export -f print_installation_summary

# Export arrays (bash 4.3+)
export SUCCESSFUL_PACKAGES
export FAILED_PACKAGES
export SKIPPED_PACKAGES

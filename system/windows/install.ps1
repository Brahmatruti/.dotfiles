# Source Windows Utilities
. "$env:USERPROFILE\.dotfiles\scripts\utils\utils_windows.ps1"

Write-Section "Running Windows Dotfiles Setup"

#==================================
# Development Machine Check
#==================================
Write-Title "Development Machine Check"

if ($env:IS_DEVELOPMENT_MACHINE -eq "true") {
    Write-Host "Development machine detected - installing development packages..." -ForegroundColor "Green"

    # Install additional development packages
    Write-Title "Installing additional development packages"
    Install-WingetPackage "Python 3.12" "Python.Python.3.12"
    Install-WingetPackage "NodeJS LTS" "OpenJS.NodeJS.LTS"
    Install-WingetPackage "Docker Desktop" "Docker.DockerDesktop"
    Install-WingetPackage "Git" "Git.Git"
    Install-WingetPackage "Git LFS" "GitHub.GitLFS"

    # Install cloud tools
    Install-WingetPackage "Azure CLI" "Microsoft.AzureCLI"
    Install-WingetPackage "AWS CLI" "Amazon.AWSCLI"

    Write-Success "Development environment setup completed"
}
else {
    Write-Host "Non-development machine detected - skipping development packages" -ForegroundColor "Yellow"
}

#==================================
# Setup Scripts
#==================================

# Setup Variables
Invoke-Script ".dotfiles\system\windows\setup_variables.ps1"

# Setup Config
Invoke-Script ".dotfiles\system\windows\setup_config.ps1"

# Setup Packages
Invoke-Script ".dotfiles\system\windows\setup_packages.ps1"

# Setup AI Tools (Only on Development Machines)
if ($env:IS_DEVELOPMENT_MACHINE -eq "true") {
    $aiChoice = Read-Host "Do you want to install AI tools (Google Gemini CLI, etc.)? (y/N)"
    if ($aiChoice -eq 'y' -or $aiChoice -eq 'Y') {
        Invoke-Script ".dotfiles\system\windows\setup_ai_tools.ps1"
    }
}
else {
    Write-Host "Skipping AI tools (non-development machine)" -ForegroundColor "Yellow"
}

# Setup Cleanup
$cleanupChoice = Read-Host "Do you want to perform system cleanup (remove unnecessary apps, shortcuts)? (y/N)"
if ($cleanupChoice -eq 'y' -or $cleanupChoice -eq 'Y') {
    Invoke-Script ".dotfiles\system\windows\setup_cleanup.ps1"
}

# Setup Fonts
Invoke-Script ".dotfiles\system\windows\setup_fonts.ps1"

# Setup Shell
Invoke-Script ".dotfiles\system\windows\setup_shell.ps1"

# Generate Git Credentials
Invoke-Script ".dotfiles\system\windows\setup_git_creds.ps1"

# Setup WSL2
$wslChoice = Read-Host "Do you want to setup WSL2? (y/N)"
if ($wslChoice -eq 'y' -or $wslChoice -eq 'Y') {
    Invoke-Script ".dotfiles\system\windows\setup_wsl.ps1"
}

# Setup Complete
Write-Host -ForegroundColor Green "Uni Dotfiles Successfully Installed"
Write-Host -ForegroundColor Yellow "Please restart your computer to apply all changes"

# Source Windows Utilities
. "$env:USERPROFILE\.dotfiles\scripts\utils\utils_windows.ps1"
. "$env:USERPROFILE\.dotfiles\scripts\utils\utils_logging.ps1"
. "$env:USERPROFILE\.dotfiles\scripts\utils\utils_installation.ps1"

Write-Section "Installing WinGet Packages"

# Update Winget MS Store
Write-Title "Updating Winget MS Store"
try {
    winget source update --name msstore > $null
    Write-Success "Updated Winget Source MS Store"   
}
catch {
    Write-Error "Failed to update Winget MS Store"
}

# Initial
Write-Title "Initial Packages"
Install-WingetPackage "Firefox" "Mozilla.Firefox"
Install-WingetPackage "1Password" "AgileBits.1Password"
Install-WingetPackage "GeForceExperience" "Nvidia.GeForceExperience"

# Development (Only on Development Machines)
if ($env:IS_DEVELOPMENT_MACHINE -eq "true") {
    Write-Title "Development Packages (CLI)"
    Install-WingetPackage "Git" "Git.Git"
    Install-WingetPackage "Git LFS" "GitHub.GitLFS"
    Install-WingetPackage "Clink" "chrisant996.Clink"
    Install-WingetPackage "Alacritty" "Alacritty.Alacritty"
    Install-WingetPackage "Starship" "Starship.Starship"
    Install-WingetPackage "delta" "dandavison.delta"
    Install-WingetPackage "bat" "sharkdp.bat"
    Install-WingetPackage "eza" "eza-community.eza"
    Install-WingetPackage "micro" "zyedidia.micro"
    Install-WingetPackage "gum" "charmbracelet.gum"
    Install-WingetPackage "fzf" "junegunn.fzf"
    Install-WingetPackage "yq" "MikeFarah.yq"
    Install-WingetPackage "ripgrep" "BurntSushi.ripgrep.MSVC"
    Install-WingetPackage "lazygit" "JesseDuffield.lazygit"
    Install-WingetPackage "lazydocker" "JesseDuffield.Lazydocker"
    Install-WingetPackage "Python 3.12" "Python.Python.3.12"
    Install-WingetPackage "NodeJS" "OpenJS.NodeJS"
    Install-WingetPackage "PowerShell" "Microsoft.Powershell"

    Write-Title "Development Packages (GUI)"
    Install-WingetPackage "JetBrains.Rider" "JetBrains.Rider"
    Install-WingetPackage "VisualStudioCode" "Microsoft.VisualStudioCode"
    Install-WingetPackage "Fork" "Fork.Fork"
    Install-WingetPackage "RenderDoc" "BaldurKarlsson.RenderDoc"
    Install-WingetPackage "DockerDesktop" "Docker.DockerDesktop"
    Install-WingetPackage "Insomnia" "Insomnia.Insomnia"
}
else {
    Write-Host "Skipping development packages (non-development machine)" -ForegroundColor "Yellow"
}

# Art
Write-Title "Art Packages"
Install-WingetPackage "Blender" "BlenderFoundation.Blender"
Install-WingetPackage "Affinity Photo 2" "9P8DVF1XW02V" "msstore"
Install-WingetPackage "Affinity Designer 2" "9N2D0P16C80H" "msstore"

# Productivity
Write-Title "Productivity Packages"
Install-WingetPackage "Notion" "Notion.Notion"
Install-WingetPackage "Dropbox" "Dropbox.Dropbox"
Install-WingetPackage "Flameshot" "Flameshot.Flameshot"
Install-WingetPackage "muCommander" "muCommander.muCommander"
Install-WingetPackage "WizTree" "AntibodySoftware.WizTree"

# Game
Write-Title "Game Packages"
Install-WingetPackage "EpicGamesLauncher" "EpicGames.EpicGamesLauncher"
Install-WingetPackage "Steam" "Valve.Steam"

# Social
Write-Title "Social Packages"
Install-WingetPackage "Mailbird" "XP9KHKVP3JKR39" "msstore"
Install-WingetPackage "Discord" "Discord.Discord"
Install-WingetPackage "TelegramDesktop" "Telegram.TelegramDesktop"
Install-WingetPackage "WhatsApp" "9NKSQGP7F2NH" "msstore"

# Media
Write-Title "Media Packages"
Install-WingetPackage "Spotify" "9NCBCSZSJRSB" "msstore"
Install-WingetPackage "Disney+" "9NXQXXLFST89" "msstore"
Install-WingetPackage "Amazon Prime" "9P6RC76MSMMJ" "msstore"
Install-WingetPackage "Apple TV (Preview)" "9NM4T8B9JQZ1" "msstore"
Install-WingetPackage "VLC" "VideoLAN.VLC"
Install-WingetPackage "7zip" "7zip.7zip"
Install-WingetPackage "HandBrake" "HandBrake.HandBrake"
Install-WingetPackage "OBS Studio" "OBSProject.OBSStudio"

# Utilities
Write-Title "Utilities Packages"
Install-WingetPackage "PowerToys" "Microsoft.PowerToys"
Install-WingetPackage "SpeedTest" "Ookla.Speedtest.CLI"
Install-WingetPackage "Deluge" "DelugeTeam.Deluge"
Install-WingetPackage "Bitdefender" "Bitdefender.Bitdefender"
Install-WingetPackage "NeoFetch" "nepnep.neofetch-win"

# Package Managers (from old scripts)
Write-Title "Package Managers"
Install-WingetPackage "Chocolatey" "Chocolatey.Chocolatey"
# Install-WingetPackage "Miniconda3" "Anaconda.Miniconda3"


# Additional NAS Tools
Write-Title "Additional NAS Tools"
Install-WingetPackage "pCloud Drive" "pCloudAG.pCloudDrive"
Install-WingetPackage "Google Drive" "Google.Drive"
Install-WingetPackage "MEGASync" "Mega.MEGASync"
Install-WingetPackage "QNAP Qsync" "QNAP.Qsync"
Install-WingetPackage "Synology Drive Client" "Synology.DriveClient"


#==================================
# Development Tools (Only on Development Machines)
#==================================
if ($env:IS_DEVELOPMENT_MACHINE -eq "true") {
    Write-Title "Development Tools"
    Install-WingetPackage "Docker Desktop" "Docker.DockerDesktop"
    Install-WingetPackage "Python 3.12" "Python.Python.3.12"
    Install-WingetPackage "NodeJS" "OpenJS.NodeJS"
    Install-WingetPackage "Git" "Git.Git"
    Install-WingetPackage "Git LFS" "GitHub.GitLFS"

    # Cloud and Infrastructure Tools
    Write-Title "Cloud and Infrastructure Tools"
    Install-WingetPackage "Azure CLI" "Microsoft.AzureCLI"
    Install-WingetPackage "AWS CLI" "Amazon.AWSCLI"

     # Additional Remotes Tools
    Write-Title "Additional Remotes Tools"
    Install-WingetPackage "MobaXterm" "Mobatek.MobaXterm"
    Install-WingetPackage "GitHub Desktop" "GitHub.GitHubDesktop"

    # AI Tools (from old scripts)
    Write-Title "AI Tools"
    Install-WingetPackage "NodeJS LTS" "OpenJS.NodeJS.LTS"
    # Note: Google Gemini CLI will be installed via npm after Node.js

    # .NET Development Tools (from old scripts)
    Write-Title ".NET Development Tools"
    Install-WingetPackage ".NET SDK" "Microsoft.DotNet.SDK.8"
    Install-WingetPackage ".NET Runtime" "Microsoft.DotNet.Runtime.8"

    # Notepad++ (from old scripts)
    Write-Title "Notepad++"
    Install-WingetPackage "Notepad++" "Notepad++.Notepad++"
}
else {
    Write-Host "Skipping development tools (non-development machine)" -ForegroundColor "Yellow"
}


#==================================
# Error Handling Functions
#==================================
function Install-WingetPackageWithRetry {
    param(
        [string]$Description,
        [string]$PackageId,
        [string]$Source = "winget"
    )

    $maxRetries = 2
    $retryCount = 0

    while ($retryCount -lt $maxRetries) {
        try {
            if ($Source -eq "msstore") {
                Write-Host "⟲ Installing $Description..." -ForegroundColor Cyan
                winget install --id $PackageId --source msstore --accept-package-agreements --accept-source-agreements | Out-Null
            } else {
                Write-Host "⟲ Installing $Description..." -ForegroundColor Cyan
                winget install --id $PackageId --accept-package-agreements --accept-source-agreements | Out-Null
            }

            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ $Description installed successfully" -ForegroundColor Green
                return $true
            } else {
                throw "Installation failed with exit code $LASTEXITCODE"
            }
        }
        catch {
            $retryCount++
            Write-Host "⚠ Attempt $retryCount failed for $Description" -ForegroundColor Yellow

            if ($retryCount -lt $maxRetries) {
                Write-Host "⟲ Retrying in 3 seconds..." -ForegroundColor Cyan
                Start-Sleep -Seconds 3
            }
        }
    }

    Write-Host "✗ Failed to install $Description after $maxRetries attempts" -ForegroundColor Red
    return $false
}

function Handle-PackageError {
    param(
        [string]$Description,
        [string]$PackageId
    )

    Write-Host "⚠ Package $Description ($PackageId) failed to install" -ForegroundColor Yellow
    Write-Host "❓ Would you like to continue with other packages? (Y/n): " -ForegroundColor Cyan -NoNewline

    # Auto-continue with 3-second timeout, default "yes"
    try {
        $response = Read-Host -Timeout 3
    }
    catch {
        Write-Host ""
        Write-Host "ℹ No response received within 3 seconds, continuing automatically..." -ForegroundColor Blue
        $response = "y"
    }

    if ($response -notmatch "^[Yy]$") {
        Write-Host "✗ Installation cannot continue. Exiting." -ForegroundColor Red
        exit 1
    }
}

#==================================
# Enhanced Package Installation
#==================================
function Install-WingetPackage {
    param(
        [string]$Description,
        [string]$PackageId,
        [string]$Source = "winget"
    )

    try {
        $result = Install-WingetPackageWithRetry -Description $Description -PackageId $PackageId -Source $Source
        if (-not $result) {
            Handle-PackageError -Description $Description -PackageId $PackageId
        }
    }
    catch {
        Write-Host "✗ Error installing $Description`: $_" -ForegroundColor Red
        Handle-PackageError -Description $Description -PackageId $PackageId
    }
}

#==================================
# Installation Summary
#==================================
Write-InstallationSummary

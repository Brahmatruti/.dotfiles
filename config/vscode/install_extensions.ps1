# VSCode Extensions Installer
# This script installs VSCode extensions from the extensions.txt file

param(
    [switch]$SkipConfirmation
)

# Function to install VSCode extensions
function Install-VSCodeExtensions {
    Write-Host "Installing Visual Studio Code extensions..." -ForegroundColor "Yellow"

    # Check if VSCode is installed
    $vscodePath = Get-Command code -ErrorAction SilentlyContinue
    if (-not $vscodePath) {
        Write-Error "VSCode is not installed or not in PATH. Please install VSCode first."
        return
    }

    # Read extensions from file
    $extensionsFile = Join-Path -Path $PSScriptRoot -ChildPath "extensions.txt"
    if (-not (Test-Path $extensionsFile)) {
        Write-Error "Extensions file not found: $extensionsFile"
        return
    }

    $extensions = Get-Content $extensionsFile | Where-Object {
        $_.Trim() -ne "" -and $_.Trim() -notmatch "^#"
    } | ForEach-Object {
        $_.Split("#")[0].Trim()
    }

    if ($extensions.Count -eq 0) {
        Write-Warning "No extensions found in extensions.txt"
        return
    }

    Write-Host "Found $($extensions.Count) extensions to install:" -ForegroundColor "Green"

    # Install each extension
    foreach ($extension in $extensions) {
        try {
            Write-Host "Installing $extension..." -ForegroundColor "Cyan"
            code --install-extension $extension --force
            Write-Host "✓ $extension installed successfully" -ForegroundColor "Green"
        }
        catch {
            Write-Warning "Failed to install $extension : $_"
        }
    }

    Write-Host "VSCode extensions installation completed!" -ForegroundColor "Green"
}

# Function to list installed extensions
function Get-InstalledExtensions {
    Write-Host "Checking installed VSCode extensions..." -ForegroundColor "Yellow"

    try {
        $installed = code --list-extensions
        if ($installed) {
            Write-Host "Currently installed extensions:" -ForegroundColor "Green"
            $installed | ForEach-Object { Write-Host "  - $_" -ForegroundColor "Cyan" }
        } else {
            Write-Host "No extensions currently installed." -ForegroundColor "Yellow"
        }
    }
    catch {
        Write-Error "Failed to get installed extensions: $_"
    }
}

# Main execution
if (-not $SkipConfirmation) {
    $choice = Read-Host "Do you want to install VSCode extensions? (y/N)"
    if ($choice -ne 'y' -and $choice -ne 'Y') {
        Write-Host "Extension installation cancelled." -ForegroundColor "Yellow"
        exit 0
    }
}

# Install extensions
Install-VSCodeExtensions

# Show installed extensions
Get-InstalledExtensions

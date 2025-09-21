# Windows Cleanup Script (migrated from old scripts)
Write-Section "Performing Windows Cleanup"

# Remove Desktop Shortcuts
function Remove-Desktop-Shortcuts {
    $UserDesktopPath = [Environment]::GetFolderPath("Desktop")
    $PublicDesktopPath = "${env:Public}\Desktop"

    Write-Host "Deleting shortcuts in desktop:" -ForegroundColor "Green"

    try {
        Get-ChildItem -Path "${UserDesktopPath}\*" -Include "*.lnk", "*.url" -Recurse | Remove-Item -Force
        Get-ChildItem -Path "${PublicDesktopPath}\*" -Include "*.lnk", "*.url" -Recurse | Remove-Item -Force

        Write-Success "Shortcuts in desktop successfully deleted"
    }
    catch {
        Write-Error "Failed to remove desktop shortcuts: $_"
    }
}

# Remove Unnecessary Windows Features
Write-Title "Disabling unnecessary Windows features"
try {
    # Disable Windows Media Player
    Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart

    # Disable Internet Explorer (if present)
    Disable-WindowsOptionalFeature -Online -FeatureName "Internet-Explorer-Optional-amd64" -NoRestart

    # Disable Windows Sandbox (if not needed)
    Disable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -NoRestart

    Write-Success "Unnecessary Windows features disabled"
}
catch {
    Write-Error "Failed to disable Windows features: $_"
}

# Remove Unnecessary App Packages
Write-Title "Removing unnecessary app packages"
$appsToRemove = @(
    "Microsoft.Getstarted",
    "Microsoft.GetHelp",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.3DBuilder",
    "Microsoft.WindowsAlarms",
    "Microsoft.BingFinance",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingWeather",
    "Microsoft.MicrosoftOfficeHub"
)

foreach ($app in $appsToRemove) {
    try {
        Get-AppxPackage $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppXProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Host "Removed $app" -ForegroundColor "Green"
    }
    catch {
        Write-Warning "Failed to remove $app : $_"
    }
}

# Clean up desktop shortcuts
Remove-Desktop-Shortcuts

Write-Success "Windows cleanup completed"

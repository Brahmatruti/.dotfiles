# Windows Configuration Script (migrated from old scripts)
Write-Section "Configuring Windows System Settings"

# Function to set registry values
function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [string]$Type = "DWord"
    )

    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }

        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
        Write-Host "Set $Name = $Value in $Path" -ForegroundColor "Green"
    }
    catch {
        Write-Error "Failed to set registry value $Name in $Path : $_"
    }
}

# Explorer Configuration
Write-Title "Configuring Windows Explorer"
try {
    # Show file extensions
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

    # Show hidden files
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

    # Launch Explorer to This PC
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

    Write-Success "Windows Explorer configured"
}
catch {
    Write-Error "Failed to configure Windows Explorer: $_"
}

# Taskbar Configuration
Write-Title "Configuring Taskbar"
try {
    # Small taskbar icons
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

    Write-Success "Taskbar configured"
}
catch {
    Write-Error "Failed to configure Taskbar: $_"
}

# Power Configuration
Write-Title "Configuring Power Settings"
try {
    # Set power plan to high performance
    $highPerfPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object {$_.ElementName -eq "High performance"}
    if ($highPerfPlan) {
        $highPerfPlan.Activate()
        Write-Host "Activated High Performance power plan" -ForegroundColor "Green"
    }

    # Set monitor timeout to 10 minutes
    powercfg -change -monitor-timeout-ac 10
    powercfg -change -monitor-timeout-dc 10

    Write-Success "Power settings configured"
}
catch {
    Write-Error "Failed to configure power settings: $_"
}

# Privacy Settings
Write-Title "Configuring Privacy Settings"
try {
    # Disable advertising ID
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0

    # Disable application launch tracking
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

    # Disable suggested content in settings
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338394Enabled" 0
    Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338396Enabled" 0

    Write-Success "Privacy settings configured"
}
catch {
    Write-Error "Failed to configure privacy settings: $_"
}

# Windows Update Configuration
Write-Title "Configuring Windows Update"
try {
    # Enable automatic updates
    Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0

    # Configure to notify before download
    Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

    # Include recommended updates
    Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1

    Write-Success "Windows Update configured"
}
catch {
    Write-Error "Failed to configure Windows Update: $_"
}

# Context Menu Configuration
Write-Title "Configuring Context Menu"
try {
    # Enable classic context menu (Windows 11)
    $regPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value "" -Type String

    Write-Success "Context menu configured"
}
catch {
    Write-Error "Failed to configure context menu: $_"
}

Write-Success "Windows system configuration completed"

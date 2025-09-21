# AI Tools Setup for Windows (Only on Development Machines)
Write-Section "Setting up AI Tools"

if ($env:IS_DEVELOPMENT_MACHINE -eq "true") {
    # Install Google Gemini CLI
    Write-Title "Installing Google Gemini CLI"
    try {
        # Ensure Node.js is available
        $nodePath = Get-Command node -ErrorAction SilentlyContinue
        if (-not $nodePath) {
            Write-Warning "Node.js not found. Installing Node.js LTS..."
            Install-WingetPackage "NodeJS LTS" "OpenJS.NodeJS.LTS"
            Refresh-Environment
        }

        # Install Google Gemini CLI globally
        Write-Host "Installing Google Gemini CLI..." -ForegroundColor "Green"
        npm install -g @google/gemini-cli

        Write-Success "Google Gemini CLI installed successfully"
    }
    catch {
        Write-Error "Failed to install Google Gemini CLI: $_"
    }

    # Install other AI tools if needed
    Write-Title "Installing additional AI tools"
    try {
        # Add any other AI tools here as needed
        # Install-WingetPackage "AI Tool Name" "Package.ID"
        Write-Success "Additional AI tools setup completed"
    }
    catch {
        Write-Error "Failed to install additional AI tools: $_"
    }
}
else {
    Write-Host "Skipping AI tools (non-development machine)" -ForegroundColor "Yellow"
}

# VSCode Configuration

This directory contains centralized VSCode configuration files that are shared across all operating systems.

## Files

- `settings.json` - VSCode user settings (editor preferences, formatting, themes)
- `extensions.txt` - List of VSCode extensions to install
- `install_extensions.sh` - Shell script to install extensions (Linux/macOS)
- `install_extensions.ps1` - PowerShell script to install extensions (Windows)

## Usage

### Automatic Installation

The VSCode configuration will be automatically applied when you run the dotfiles installation for your OS:

- **Ubuntu**: Run `system/ubuntu/install.sh`
- **Windows**: Run `system/windows/install.ps1`
- **macOS**: Run `system/macos/install.sh`
- **Arch Linux**: Run `system/arch/install.sh`
- **Alpine Linux**: Run `system/alpine/install.sh`

### Manual Installation

#### 1. Copy Settings

Copy the settings file to your VSCode user directory:

**Linux/macOS:**
```bash
cp config/vscode/settings.json ~/.config/Code/User/settings.json
```

**Windows:**
```powershell
Copy-Item "config\vscode\settings.json" "$env:APPDATA\Code\User\settings.json"
```

#### 2. Install Extensions

**Linux/macOS:**
```bash
./config/vscode/install_extensions.sh
```

**Windows:**
```powershell
.\config\vscode\install_extensions.ps1
```

Or run without confirmation:
```bash
.\config\vscode\install_extensions.ps1 -SkipConfirmation
```

## Configuration Details

### Editor Settings
- **Font**: Hack Nerd Font with ligatures
- **Font Size**: 13px
- **Line Height**: 25px
- **Tab Size**: 2 spaces
- **Format on Save**: Enabled
- **Minimap**: Disabled
- **Word Wrap**: Enabled

### Theme
- **Icon Theme**: Material Icon Theme
- **Color Theme**: Material Theme
- **Terminal Colors**: One Dark inspired color scheme

### Extensions Categories

The extensions are organized into categories:

1. **Core Language Support** - Python, JavaScript, TypeScript, Java, C/C++, PHP
2. **Remote & Container Development** - Remote development tools
3. **DevOps / Cloud** - Terraform, Ansible, Docker, Azure, AWS
4. **Git & Collaboration** - GitLens, GitHub integration, Live Share
5. **UI & Themes** - Material themes, icons, rainbow brackets
6. **Web Development** - HTML/CSS support, auto-rename tags
7. **Productivity** - Prettier, Todo Tree, spell checker
8. **AI Assistants** - GitHub Copilot, Claude

## Customization

### Adding New Extensions

1. Edit `extensions.txt`
2. Add the extension ID in the format: `extension-id # description`
3. Run the installation script

### Modifying Settings

1. Edit `settings.json`
2. Copy to your VSCode user directory
3. Restart VSCode or use `Ctrl+,` to open settings

### Platform-Specific Settings

For platform-specific settings, you can create additional settings files:

- `settings-linux.json` - Linux-specific settings
- `settings-windows.json` - Windows-specific settings
- `settings-macos.json` - macOS-specific settings

These will be automatically merged with the main settings file.

## Troubleshooting

### Extensions Not Installing

1. Ensure VSCode is properly installed
2. Check that `code` command is in your PATH
3. Try running VSCode manually first
4. Check internet connection

### Settings Not Applied

1. Ensure the settings file is in the correct location
2. Restart VSCode completely
3. Check for syntax errors in JSON
4. Look at VSCode's developer console for errors

### Permission Issues (Linux/macOS)

```bash
# Make scripts executable
chmod +x config/vscode/install_extensions.sh

# Run with sudo if needed
sudo ./config/vscode/install_extensions.sh
```

## Contributing

When adding new extensions or settings:

1. Test on multiple platforms if possible
2. Follow the existing categorization
3. Include helpful comments
4. Update this README if needed

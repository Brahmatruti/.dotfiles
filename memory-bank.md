# Uni Dotfiles Memory Bank

## Repository Architecture & Implementation Guide

### 📁 **Project Structure Overview**

```
Uni_dotfiles/
├── 📁 config/                    # Centralized application configurations
│   ├── 📁 vscode/               # VSCode settings and extensions
│   │   ├── settings.json        # Universal VSCode settings
│   │   ├── extensions.txt       # Extension list with descriptions
│   │   ├── install_extensions.sh # Linux/macOS installer
│   │   ├── install_extensions.ps1 # Windows installer
│   │   └── README.md            # VSCode configuration guide
│   ├── 📁 fish/                 # Fish shell configuration
│   ├── 📁 bash/                 # Bash shell configuration
│   ├── 📁 git/                  # Git configuration
│   └── 📁 [other-apps]/         # Other application configs
├── 📁 system/                   # OS-specific installation scripts
│   ├── 📁 ubuntu/               # Ubuntu 22.04+ setup
│   ├── 📁 windows/              # Windows 10/11 setup
│   ├── 📁 macos/                # macOS Monterey+ setup
│   ├── 📁 arch/                 # Arch Linux setup
│   ├── 📁 alpine/               # Alpine Linux setup
│   └── 📁 [future-os]/          # Future OS support
├── 📁 scripts/                  # Universal installation scripts
├── 📁 oldscripts/               # Legacy scripts (reference only)
└── 📁 [root-files]/             # Configuration files
```

### 🏗️ **Architecture Principles**

#### 1. **Centralized Configuration Management**
- **Single Source of Truth**: All app configs in `config/` directory
- **OS-Agnostic**: Settings work across all supported operating systems
- **Version Controlled**: All configurations tracked in git
- **Modular**: Each application has its own subdirectory

#### 2. **OS-Specific Implementation**
- **Package Managers**: Native to each OS (apt, pacman, apk, winget, brew)
- **Installation Scripts**: Separate per OS in `system/[os]/`
- **Conditional Logic**: Environment-specific configurations
- **Cross-Platform Tools**: Tools that work consistently across OS

#### 3. **Development Workflow**
- **Interactive Prompts**: User choice for optional components
- **Development Mode**: Special setup for development machines
- **Modular Installation**: Install only what's needed
- **Error Handling**: Robust error handling and rollback

### 🔧 **Core Technologies**

#### Package Managers
- **Ubuntu**: `apt`, `snap`, `flatpak`
- **Windows**: `winget`, `chocolatey`
- **macOS**: `brew`, `mas`
- **Arch**: `pacman`, `yay` (AUR)
- **Alpine**: `apk`

#### Development Tools
- **Languages**: Python, JavaScript, Java, C/C++, PHP
- **Infrastructure**: Docker, Ansible, Terraform
- **Version Control**: Git, Git LFS
- **Editors**: VSCode, Neovim, Micro
- **Shells**: Fish, Zsh, Bash, PowerShell

#### System Tools
- **Terminal**: Alacritty, Windows Terminal
- **Multiplexers**: Tmux
- **File Managers**: Ranger, Midnight Commander
- **Network**: NFS, Autofs (Linux)

### 📋 **Installation Flow**

#### 1. **Pre-Installation**
```bash
# Download dotfiles
git clone <repository-url>
cd Uni_dotfiles

# Make scripts executable (Linux/macOS)
find . -name "*.sh" -exec chmod +x {} \;
```

#### 2. **OS Detection & Setup**
```bash
# Automatic OS detection
./scripts/setup.sh

# Manual OS selection
./system/ubuntu/install.sh    # Ubuntu
./system/windows/install.ps1  # Windows
./system/macos/install.sh     # macOS
./system/arch/install.sh      # Arch Linux
./system/alpine/install.sh    # Alpine Linux
```

#### 3. **Interactive Prompts**
- **Development Machine**: Install dev tools?
- **Optional Components**: VSCode extensions, NFS, cleanup?
- **Confirmation**: All installations require user approval

### 🎯 **Key Features by OS**

#### Ubuntu (system/ubuntu/)
- **NFS Support**: Autofs configuration for network shares
- **Gnome Integration**: Extensions and desktop customization
- **Server/Desktop**: Works for both use cases
- **PPAs**: Additional repositories for latest software

#### Windows (system/windows/)
- **WinGet**: Modern Windows package management
- **PowerShell**: Native Windows scripting
- **WSL Support**: Windows Subsystem for Linux
- **Registry**: Windows configuration management

#### macOS (system/macos/)
- **Homebrew**: Primary package manager
- **MAS**: Mac App Store integration
- **Launch Agents**: Background services
- **Security**: Gatekeeper and SIP considerations

#### Arch Linux (system/arch/)
- **AUR Support**: Community packages via yay
- **Rolling Release**: Latest software versions
- **Minimal Base**: Build up from core system
- **Pacman**: Fast native package manager

#### Alpine Linux (system/alpine/)
- **Lightweight**: Minimal resource usage
- **Security**: Built with security in mind
- **Docker**: Often used as base image
- **APK**: Simple package management

### 🔒 **Security Considerations**

#### File Permissions
```bash
# Scripts should be executable
chmod +x system/*/install.sh
chmod +x config/vscode/install_extensions.sh

# Sensitive files should be protected
chmod 600 config/ssh/*
chmod 700 ~/.ssh
```

#### Package Verification
- **GPG Keys**: Verify package signatures
- **HTTPS**: Use secure connections for downloads
- **User Confirmation**: Interactive prompts for installations
- **Rollback**: Ability to undo changes

#### Network Security
- **Firewall**: Configure appropriate firewall rules
- **Updates**: Keep systems updated
- **Minimal Install**: Only install necessary packages

### 🧪 **Testing Strategy**

#### Local Testing
```bash
# Test individual components
./system/ubuntu/setup_packages.sh

# Test with minimal options
./system/ubuntu/install.sh <<< $'n\nn\n'

# Test VSCode setup
./config/vscode/install_extensions.sh
```

#### CI/CD Testing
- **GitHub Actions**: Automated testing workflows
- **Docker**: Containerized testing environments
- **Vagrant**: Virtual machine testing
- **Multi-OS**: Test on all supported platforms

#### Validation Checks
- **Package Installation**: Verify all packages install
- **Configuration Files**: Check syntax and validity
- **Permissions**: Ensure correct file permissions
- **Dependencies**: Verify dependency resolution

### 📚 **Documentation Structure**

#### Root README
- **Overview**: Project description and features
- **Installation**: Quick start guides
- **Architecture**: High-level design
- **Contributing**: Development guidelines

#### OS-Specific READMEs
- **Features**: OS-specific capabilities
- **Requirements**: System requirements
- **Installation**: Detailed setup instructions
- **Troubleshooting**: Common issues and solutions

#### Configuration READMEs
- **VSCode**: Editor configuration guide
- **Shell**: Shell customization guide
- **Git**: Version control setup
- **Applications**: Individual app configurations

### 🔄 **Maintenance & Updates**

#### Regular Tasks
- **Package Updates**: Keep package lists current
- **Security Patches**: Monitor for vulnerabilities
- **Compatibility**: Test with new OS versions
- **Documentation**: Update guides and examples

#### Version Control
```bash
# Check for updates
git pull origin main

# Update submodules
git submodule update --init --recursive

# Test changes
./test-setup.sh
```

#### Backup Strategy
- **Dotfiles Backup**: Before major changes
- **Configuration Export**: Save current settings
- **Rollback Plan**: Ability to revert changes
- **Migration Guide**: Update instructions

### 🤖 **AI Development Integration**

#### Code Generation
- **Extension Development**: VSCode extension templates
- **Script Generation**: Automated script creation
- **Configuration Files**: Dynamic config generation
- **Documentation**: Auto-generated guides

#### Intelligent Assistance
- **Context Awareness**: OS-specific recommendations
- **Error Diagnosis**: Automated troubleshooting
- **Optimization**: Performance suggestions
- **Security**: Vulnerability detection

#### Learning & Adaptation
- **Usage Patterns**: Learn user preferences
- **Custom Configurations**: Personalized setups
- **Best Practices**: Recommend improvements
- **Migration**: Assist with updates

### 📈 **Performance Optimization**

#### Installation Speed
- **Parallel Downloads**: Concurrent package installation
- **Caching**: Package cache for faster installs
- **Minimal Dependencies**: Only install required packages
- **Smart Detection**: Skip already installed items

#### System Resources
- **Memory Usage**: Monitor and optimize
- **Disk Space**: Efficient package selection
- **Network**: Optimize download strategies
- **CPU**: Background processing where possible

### 🌐 **Network & Connectivity**

#### Offline Support
- **Package Caching**: Local package repositories
- **Configuration Files**: Work without internet
- **Documentation**: Available offline
- **Scripts**: Self-contained installation

#### Remote Installation
- **SSH Setup**: Remote system configuration
- **Network Shares**: NFS/SMB configuration
- **Cloud Integration**: AWS/Azure setup
- **VPN Support**: Remote development setup

### 📦 **Package Management Strategy**

#### Ubuntu
```bash
# APT for system packages
sudo apt update && sudo apt upgrade
sudo apt install package-name

# Snap for applications
sudo snap install package-name

# Flatpak for GUI apps
flatpak install flathub package-name
```

#### Windows
```powershell
# WinGet for modern packages
winget install package-id

# Chocolatey for legacy support
choco install package-name
```

#### macOS
```bash
# Homebrew for packages
brew install package-name

# Casks for applications
brew install --cask app-name

# MAS for App Store
mas install app-id
```

### 🔧 **Troubleshooting Guide**

#### Common Issues
1. **Permission Denied**: Check file permissions and ownership
2. **Package Not Found**: Update package lists and repositories
3. **Dependency Conflicts**: Use package manager to resolve
4. **Network Issues**: Check connectivity and firewall settings

#### Debug Mode
```bash
# Enable verbose logging
export DEBUG=1
./install.sh

# Check system information
uname -a
lsb_release -a
```

#### Recovery Options
```bash
# Backup current configuration
cp ~/.config ~/.config.backup

# Restore from backup
cp ~/.config.backup ~/.config

# Remove and reinstall
./uninstall.sh
./install.sh
```

### 📝 **Contributing Guidelines**

#### Code Style
- **Shell Scripts**: Follow Google Shell Style Guide
- **PowerShell**: Use PowerShell best practices
- **Documentation**: Clear, concise, and comprehensive
- **Comments**: Explain complex logic and decisions

#### Testing Requirements
- **Multi-OS**: Test on all supported platforms
- **Idempotent**: Scripts should be safe to run multiple times
- **Error Handling**: Graceful failure and recovery
- **Documentation**: Update docs for any changes

#### Review Process
1. **Local Testing**: Test changes locally
2. **Code Review**: Submit pull request
3. **CI/CD**: Automated testing
4. **Documentation**: Update relevant docs
5. **Merge**: Integrate approved changes

### 🎯 **Future Enhancements**

#### Planned Features
- **Container Support**: Docker-based installation
- **Cloud Integration**: AWS/Azure/GCP setup
- **CI/CD Templates**: GitHub Actions workflows
- **Mobile Support**: Android/iOS development tools
- **Gaming Setup**: Game development environment

#### Technology Upgrades
- **Package Managers**: Latest versions and features
- **Security Tools**: Enhanced security scanning
- **Performance**: Faster installation and configuration
- **Monitoring**: System health and usage tracking

#### Community Features
- **Plugin System**: Extensible architecture
- **Theme Support**: Multiple configuration themes
- **Localization**: Multi-language support
- **Accessibility**: WCAG compliance

---

## 📄 **License & Attribution**

This memory bank is part of the Uni Dotfiles project, licensed under the MIT License. It serves as comprehensive documentation for developers, contributors, and AI assistants working with this repository.

**Last Updated**: 2025-01-21
**Version**: 2.0
**Maintainer**: Uni Dotfiles Team

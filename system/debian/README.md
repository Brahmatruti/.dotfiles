?# Debian Dotfiles Setup

Comprehensive Debian development environment setup with modern tools and configurations, maintaining uniformity with Ubuntu features.

## 🚀 Quick Start

```bash
# Download and run the installer
bash -c "$(wget --no-cache -qO - https://raw.github.com/brahmatruti/.dotfiles/main/scripts/setup.sh)"
```

## 📋 Features

### Development Tools
- **Docker & Docker Compose** - Container development
- **Ansible** - Infrastructure automation
- **Terraform** - Infrastructure as Code
- **NVM & Node.js LTS** - JavaScript development
- **OpenJDK 17** - Java development
- **Python 3** - Python development environment

### System Tools
- **NFS & Autofs** - Network file system support
- **Git & Git LFS** - Version control
- **Neovim** - Modern text editor
- **Tmux** - Terminal multiplexer
- **Fish/Zsh/Bash** - Shell environments

### Desktop Environment
- **Alacritty** - GPU-accelerated terminal
- **Gnome Extensions** - Enhanced desktop experience
- **Flatpak & Snap** - Application management

## 🔧 Installation Options

### Interactive Setup
```bash
./system/debian/install.sh
```

### Development Machine Setup
During installation, you'll be prompted:
- **Development Machine**: Installs additional dev tools (Python, Java, Node.js, Docker, etc.)
- **NFS Setup**: Configure NFS mounts (optional)

## 📦 Package Managers

### APT Packages
- **System**: `build-essential`, `git`, `curl`, `wget`
- **Development**: `python3`, `openjdk-17-jdk`, `nodejs`
- **Tools**: `tmux`, `neovim`, `htop`, `jq`

### Snap Packages
- **VS Code** - Code editor
- **1Password** - Password manager
- **GitKraken** - Git GUI

### Flatpak Packages
- **Firefox** - Web browser
- **Discord** - Communication
- **Spotify** - Music player

## ⚙️ Configuration

### VSCode Setup
- **Settings**: Centralized in `config/vscode/settings.json`
- **Extensions**: 50+ curated extensions for development
- **Themes**: Material Design theme with custom colors

### Shell Configuration
- **Fish Shell** - Modern shell with plugins
- **Starship Prompt** - Beautiful shell prompt
- **Custom Aliases** - Productivity shortcuts

### Development Environment
- **Python**: Virtual environments with pip
- **Node.js**: NVM for version management
- **Java**: OpenJDK 17 with Maven/Gradle support

## 🔗 NFS Configuration

### Setup NFS Mounts
```bash
# Edit NFS configuration
sudo nano /etc/auto.nfs

# Add your NFS servers
# dlq_pod_data_sync    -fstype=nfs,nconnect=4,proto=tcp,rw,async     172.172.172.251:/dlq_prxmx_pod_data
# dlq_db_data_sync     -fstype=nfs,nconnect=4,proto=tcp,rw,async     172.172.172.251:/dlq_prxmx_vm_data

# Restart autofs
sudo systemctl restart autofs
```

### Access NFS Mounts
NFS shares are automatically mounted under `/media/` when accessed.

## 🛠️ Customization

### Add Custom Packages
Edit `system/debian/setup_packages.sh`:
```bash
# Add your packages
apt_install "Your Package" "package-name"
```

### Modify VSCode Extensions
Edit `config/vscode/extensions.txt`:
```
your-extension-id # Your extension description
```

### Custom Shell Configuration
Add to `config/fish/config.fish` or `config/bash/.bashrc`.

## 🔍 Troubleshooting

### Package Installation Issues
```bash
# Update package lists
sudo apt update && sudo apt upgrade

# Fix broken packages
sudo apt --fix-broken install

# Clear cache
sudo apt clean && sudo apt autoclean
```

### Docker Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Start docker service
sudo systemctl start docker
sudo systemctl enable docker
```

### NFS Issues
```bash
# Check autofs status
sudo systemctl status autofs

# Test NFS mount
sudo mount -t nfs server:/path /mnt/test
```

## 📚 Additional Resources

- [Debian Documentation](https://www.debian.org/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [VSCode Documentation](https://code.visualstudio.com/docs)
- [Fish Shell Documentation](https://fishshell.com/docs/current/)

## 🤝 Contributing

1. Test changes on Debian 11/12
2. Follow existing package installation patterns
3. Update this documentation
4. Test on both desktop and server environments

## 📄 License

This configuration is part of the Uni Dotfiles project under the MIT License.

## 🔄 Debian vs Ubuntu

### Similarities
- **Same Package Managers**: APT, Snap, Flatpak
- **Same Development Tools**: Docker, Ansible, Terraform, Python, Java, Node.js
- **Same Configuration**: Identical VSCode settings and shell configurations
- **Same Features**: NFS support, Gnome integration, development environment

### Differences
- **Repository Sources**: Debian uses stable/main instead of Ubuntu PPAs
- **Package Versions**: Debian stable has older but more stable versions
- **Release Cycle**: Debian stable vs Ubuntu LTS cycle
- **Testing**: Debian testing/sid vs Ubuntu development releases

### Compatibility
- **Scripts**: Debian scripts are nearly identical to Ubuntu
- **Packages**: Most Ubuntu packages work on Debian
- **Configuration**: Same centralized configuration system
- **Extensions**: Same VSCode extensions and settings

This ensures **complete uniformity** between Ubuntu and Debian installations while respecting each distribution's unique characteristics.

# Use Ubuntu as the base image for development
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages for development
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    jq \
    shellcheck \
    bash-completion \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm for testing
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Python for testing
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for development
RUN useradd -m -s /bin/bash vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set up the workspace
WORKDIR /workspaces/uni_dotfiles

# Copy the dotfiles repository (this will be mounted at runtime)
# COPY . /workspaces/uni_dotfiles

# Set up bash profile for development
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    echo 'export EDITOR=vim' >> ~/.bashrc && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'alias ..="cd .."' >> ~/.bashrc

# Create directories for testing different OS configurations
RUN mkdir -p /tmp/test-{debian,ubuntu,alpine,arch,macos,windows,wsl,lite}

# Set the user
USER vscode

# Set environment variables for testing
ENV HOME=/home/vscode
ENV PATH="$HOME/.local/bin:$PATH"

# Default command
CMD ["/bin/bash"]

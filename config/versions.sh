#!/bin/bash
#==================================
# Uni_dotfiles Version Configuration
#==================================
# Centralized version management for all software packages
# Update versions here to upgrade across all OS systems

#==================================
# Python Versions
#==================================
PYTHON_VERSION="3.12.5"
PYTHON_MAJOR="3.12"
PYTHON_MINOR="3.12.5"

#==================================
# Node.js / NPM Versions
#==================================
NODE_VERSION="20.17.0"
NPM_VERSION="10.8.2"
YARN_VERSION="1.22.22"
PNPM_VERSION="9.7.1"

#==================================
# NVM Version
#==================================
NVM_VERSION="v0.40.1"

#==================================
# Docker Versions
#==================================
DOCKER_VERSION="27.2.0"
DOCKER_COMPOSE_VERSION="2.29.2"

#==================================
# Terraform Version
#==================================
TERRAFORM_VERSION="1.9.5"

#==================================
# Ansible Version
#==================================
ANSIBLE_VERSION="10.4.0"

#==================================
# Java Versions
#==================================
JAVA_VERSION="17.0.12"
JAVA_MAJOR="17"
OPENJDK_VERSION="17.0.12"

#==================================
# Go Version
#==================================
GO_VERSION="1.23.1"

#==================================
# Rust Version
#==================================
RUST_VERSION="1.81.0"

#==================================
# Package Manager Versions
#==================================
PIP_VERSION="24.2"
UV_VERSION="0.4.15"

#==================================
# Development Tools
#==================================
GIT_VERSION="2.46.0"
NEOVIM_VERSION="0.10.1"
TMUX_VERSION="3.4"
LAZYGIT_VERSION="0.44.1"
MICRO_VERSION="2.0.13"
HEXYLA_VERSION="1.0.0"

#==================================
# Cloud Tools
#==================================
AWS_CLI_VERSION="2.17.50"
AZURE_CLI_VERSION="2.63.0"
GCP_SDK_VERSION="493.0.0"

#==================================
# Database Tools
#==================================
POSTGRES_VERSION="16.4"
MYSQL_VERSION="8.4.2"
REDIS_VERSION="7.4.0"
MONGODB_VERSION="7.0.14"

#==================================
# Web Servers
#==================================
NGINX_VERSION="1.26.2"
APACHE_VERSION="2.4.62"

#==================================
# Programming Languages
#==================================
RUBY_VERSION="3.3.5"
PHP_VERSION="8.3.12"
DOTNET_VERSION="8.0.400"
ELIXIR_VERSION="1.17.3"
ERLANG_VERSION="27.1"

#==================================
# Container Tools
#==================================
KUBECTL_VERSION="1.31.0"
HELM_VERSION="3.15.4"
K3D_VERSION="5.7.4"
KIND_VERSION="0.24.0"
MINIKUBE_VERSION="1.34.0"

#==================================
# Monitoring Tools
#==================================
PROMETHEUS_VERSION="2.54.0"
GRAFANA_VERSION="11.2.0"
ELASTIC_VERSION="8.15.0"
LOKI_VERSION="3.2.0"

#==================================
# Security Tools
#==================================
VAULT_VERSION="1.17.5"
CONSUL_VERSION="1.19.3"
NOMAD_VERSION="1.8.4"

#==================================
# Desktop Applications
#==================================
VSCODE_VERSION="1.93.1"
GITKRAKEN_VERSION="10.3.0"
SUBLIME_VERSION="4180"
ATOM_VERSION="1.63.1"
BRAVE_VERSION="1.70.119"
FIREFOX_VERSION="130.0"
CHROME_VERSION="128.0.6613.137"

#==================================
# Communication Tools
#==================================
DISCORD_VERSION="0.0.69"
SLACK_VERSION="4.39.90"
ZOOM_VERSION="6.1.10.4658"
TEAMS_VERSION="1.7.00.24752"

#==================================
# Media Tools
#==================================
VLC_VERSION="3.0.21"
SPOTIFY_VERSION="1.2.45.454"
OBS_VERSION="30.2.3"
HANDBRAKE_VERSION="1.8.2"

#==================================
# File Management
#==================================
DROPBOX_VERSION="202.4.5551"
ONEDRIVE_VERSION="24.182.0911.0001"
MEGASYNC_VERSION="5.2.0.0"
PCLOUD_VERSION="1.12.0"

#==================================
# Development Servers
#==================================
POSTGRESQL_VERSION="16.4"
MARIADB_VERSION="11.4.3"
REDIS_SERVER_VERSION="7.4.0"
MONGODB_SERVER_VERSION="7.0.14"

#==================================
# Export Functions
#==================================

# Function to get version for a specific software
get_version() {
    local software="$1"
    local version_var="${software}_VERSION"
    echo "${!version_var:-latest}"
}

# Function to get major version
get_major_version() {
    local software="$1"
    local version_var="${software}_MAJOR"
    echo "${!version_var:-}"
}

# Function to get minor version
get_minor_version() {
    local software="$1"
    local version_var="${software}_MINOR"
    echo "${!version_var:-}"
}

# Export all version variables
export PYTHON_VERSION NODE_VERSION NPM_VERSION YARN_VERSION PNPM_VERSION
export NVM_VERSION DOCKER_VERSION DOCKER_COMPOSE_VERSION
export TERRAFORM_VERSION ANSIBLE_VERSION JAVA_VERSION OPENJDK_VERSION
export GO_VERSION RUST_VERSION PIP_VERSION UV_VERSION
export GIT_VERSION NEOVIM_VERSION TMUX_VERSION LAZYGIT_VERSION
export AWS_CLI_VERSION AZURE_CLI_VERSION GCP_SDK_VERSION
export POSTGRES_VERSION MYSQL_VERSION REDIS_VERSION MONGODB_VERSION
export NGINX_VERSION APACHE_VERSION RUBY_VERSION PHP_VERSION
export KUBECTL_VERSION HELM_VERSION VSCODE_VERSION
export DISCORD_VERSION SLACK_VERSION VLC_VERSION

# Export functions
export -f get_version get_major_version get_minor_version

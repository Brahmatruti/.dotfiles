#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_ubuntu.sh"


#==================================
# Print Section Title
#==================================
print_section "Setting up NFS and Autofs"


#==================================
# NFS Configuration
#==================================
print_title "Configuring NFS Mounts"

# Create NFS mount directory
sudo mkdir -p /media/

# Configure autofs master map
print_title "Setting up autofs master map"
sudo tee /etc/auto.master > /dev/null <<EOF
# Master map for autofs
/media/ /etc/auto.nfs --timeout=180 --ghost
EOF

# Configure NFS auto map with the mounts from old script
print_title "Setting up NFS auto map"
sudo tee /etc/auto.nfs > /dev/null <<EOF
# NFS auto map - replace these with your actual NFS server IPs and paths
# Format: mountpoint -options server:/path
#
# Example entries (uncomment and modify as needed):
# dlq_pod_data_sync    -fstype=nfs,nconnect=4,proto=tcp,rw,async     172.172.172.251:/dlq_prxmx_pod_data
# dlq_db_data_sync     -fstype=nfs,nconnect=4,proto=tcp,rw,async     172.172.172.251:/dlq_prxmx_vm_data
# nfs_dock_data_sync   -fstype=nfs,nconnect=4,proto=tcp,rw,async     172.172.172.250:/volume2/dashlab_PRXMX_SYN_NFS
EOF

# Restart and enable autofs
print_title "Restarting autofs service"
sudo systemctl restart autofs
sudo systemctl enable autofs

# Test autofs configuration
print_title "Testing autofs configuration"
sudo systemctl status autofs --no-pager

print_success "NFS and autofs configuration completed"
print_info "Edit /etc/auto.nfs with your actual NFS server details"
print_info "Mounts will be available under /media/ when accessed"

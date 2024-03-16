#!/bin/bash

# Exit script if any command fails
set -e

# Function to check if virtualization is supported
check_virtualization_support() {
    echo "Checking for virtualization support..."
    if ! grep -E 'vmx|svm' /proc/cpuinfo > /dev/null; then
        echo "Error: Your CPU does not support hardware virtualization, which is required. Exiting." >&2
        exit 1
    else
        echo "Virtualization support is enabled in your CPU."
    fi
}

# Function to install required packages
install_packages() {
    echo "Installing KVM, QEMU, virt-manager, and Docker..."
    sudo apt update
    sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
    echo "Packages installed successfully."
}

# Function to add the current user to necessary groups
configure_user_groups() {
    echo "Adding $(whoami) to libvirt and docker groups..."
     # Avoid adding the user to a group if they are already a member
    if ! groups $(whoami) | grep -q libvirt; then
        sudo usermod -aG libvirt $(whoami)
    fi

    if ! groups $(whoami) | grep -q kvm; then
        sudo usermod -aG kvm $(whoami)
    fi
    echo "User added to groups. NOTE: You will need to log out and back in for group changes to take effect."
}

# Function to enable and start required services
enable_services() {
    echo "Enabling and starting libvirtd and docker services..."
    sudo systemctl enable --now libvirtd
    # sudo systemctl enable --now kvm
    echo "Services enabled and started."
}

# Function to check system properties and loaded modules
check_system_properties() {
    echo "Verifying system properties and loaded modules..."
    if lsmod | grep -q kvm; then
        echo "KVM module is loaded."
    else
        echo "Error: KVM module is not loaded. Trying to load it..."
        sudo modprobe kvm
    fi

    if lsmod | grep -q virtio; then
        echo "Virtio module is loaded."
    else
        echo "Notice: Virtio module is not loaded. It might not be necessary depending on your setup."
    fi
}

# Main script execution
main() {
    echo "Starting setup..."
    check_virtualization_support
    install_packages
    configure_user_groups
    enable_services
    check_system_properties
    echo "Setup completed successfully. Remember to log out and back in for changes to take effect."
}

# Execute main function
main
#!/bin/bash

# Configuration variables
VM_NAME="WindowsVM"
WINDOWS_ISO="./win11x64.iso"
VIRTIO_ISO="./virtio-win.iso"
DISK_SIZE="80G"
RAM="4096"
CPUS="4"
# GPU_PCI="0000:xx:xx.x"

# Download Windows ISO
wget https://raw.githubusercontent.com/ElliotKillick/Mido/main/Mido.sh
sudo chmod u+x ./Mido.sh
./Mido.sh win11x64
[ ! -f "win11x64.iso" ] && return 1

# Download virtio drivers
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

# Create autounattend floppy image
# Unattended file pulled from dockurr/windows
sudo dd if=/dev/zero of=autounattend.img bs=1024 count=1440
sudo mkfs.vfat autounattend.img

sudo mkdir /mnt/floppy
sudo mount -o loop autounattend.img /mnt/floppy
sudo cp ./assets/win11x64.xml /mnt/floppy/autounattend.xml
sudo umount /mnt/floppy
sudo rmdir /mnt/floppy

# Create a VM
virt-install \
    --name $VM_NAME \
    --ram $RAM \
    --vcpus $CPUS \
    --os-type windows \
    --os-variant win10 \
    --boot uefi,secure=yes \
    --disk path=/var/lib/libvirt/images/${VM_NAME}.qcow2,size=$DISK_SIZE,bus=virtio,cache=none,discard=unmap \
    --cdrom $WINDOWS_ISO \
    --disk $VIRTIO_ISO,device=cdrom \
    --disk path=autounattend.img,device=floppy \
    --graphics spice,listen=none \
    --channel spicevmc \
    --network bridge=virbr0,model=virtio \
    --noautoconsole \
    --cpu host-passthrough,cache.mode=passthrough \
    --features kvm_hidden=on \
    --video qxl \
    --controller usb,model=none \
    --console pty,target_type=serial \
    --description "Windows 11 VM with USB Passthrough and VirtIO Drivers"

# Note: GPU passthrough setup
# This part is highly specific and needs to be adjusted based on your hardware setup and requirements.
# It typically involves editing the VM's XML configuration to add the hostdev section for your GPU.

# Add GPU to VM
# virsh edit $VM_NAME

# XML snippet to be added manually or scripted with xmlstarlet or similar tool:
# <hostdev mode='subsystem' type='pci' managed='yes'>
#   <source>
#     <address domain='0x0000' bus='0xXX' slot='0xXX' function='0x0'/>
#   </source>
# </hostdev>

# You might need to adjust the XML manually the first time or automate this process with sed or xmlstarlet

echo "VM $VM_NAME created. GPU passthrough needs manual configuration based on your hardware."

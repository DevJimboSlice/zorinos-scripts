#!/bin/bash

echo "Installing Packages..."
if [[ -x "./apt.sh" ]]; then
    sudo ./apt.sh
fi

echo "Installing Fonts..."
if [[ -x "./fnt.sh" ]]; then
    sudo ./fnt.sh
fi

echo "Creating Desktop Icon(s)..."
if [[ -x "./desktop.sh" ]]; then
    ./desktop.sh
fi

echo "Initializing Virt Software..."
if [[ -x "./virt.sh" ]]; then
    sudo ./virt.sh
fi

echo "Looking Good!!"
echo "Reboot now"
# reboot now
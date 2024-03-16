#!/bin/bash

Check if root privileges
if (( $EUID != 0 )); then
    echo "Please run as 'root'"
    exit
fi

# Update/Upgrade
apt-get -y update && apt-get upgrade && apt-get -y dist-upgrade

# Remove non English fonts
apt-get -y purge fonts-khmeros-core fonts-khmeros fonts-kacst \
    fonts-kacst-one fonts-lklug-sinhala fonts-lohit* fonts-nanum \
    fonts-noto-cjk fonts-takao-pgothic fonts-tibetan-machine fonts-lao \
    fonts-sil-padauk fonts-sil-abyssinica fonts-tlwg* fonts-beng* \
    fonts-deva* fonts-farsiweb fonts-gargi fonts-gubbi fonts-gujr* \
    fonts-guru* fonts-hosny-amiri fonts-kacst* fonts-kalapi \
    fonts-khmeros-core fonts-knda fonts-lao fonts-lklug-sinhala \
    fonts-lohit-beng-assamese fonts-lohit* fonts-mlym fonts-nakula \
    fonts-navilu fonts-orya* fonts-pagul fonts-sahadeva fonts-samyak* \
    fonts-sarai fonts-smc* fonts-taml fonts-telu* fonts-thai-tlwg \
    fonts-tlwg* fonts-yrsa-rasa fonts-sil-mondulkiri fonts-droid-fallback \
    && apt-get autoremove

# Install necessary packages
apt-get -y install vim wget hplip hplip-data hplip-gui \
    hplip-doc 7zip htop neofetch glabels-data mediainfo \
    cpu-checker curl chafa lcdf-typetools git virt-manager

# Install known open fonts
apt-get -y install fonts-open-sans fonts-inter fonts-wine \
    fonts-dancingscript fonts-montserrat && apt-get autoremove

# Update cache
fc-cache -f -v

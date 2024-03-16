#!/bin/bash

# path=$1

# Check if root privileges
if (( $EUID != 0 )); then
    echo "Please run as 'root'"
    exit
fi

# if [[ -n "${path}" && -e "${path}" ]]; then
#     if [[ ! -d /usr/share/fonts/googlefonts ]]; then
#         mkdir -p /usr/share/fonts/googlefonts
#     fi
    
#     # Assuming fonts are in a *.zip file
#     # tar -xvf "${path}" -C /usr/share/fonts/googlefonts
#     unzip -d . "${path}"
# fi

# "Install" fnt for installing other google fonts
tmp_dir=$(mktemp -d)
cd "${tmp_dir}"
git clone https://github.com/alexmyczko/fnt.git
cp fnt/fnt /usr/local/bin
cd && rm -rf "${tmp_dir}"

fnt update
fnt install abrilfatface
fnt install tangerine

# Update cache
fc-cache -f -v
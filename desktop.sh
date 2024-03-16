#!/bin/bash

assets=./assets

if [[ -d "${assets}" ]]; then
    for f in "${assets}/*"; do
        if [[ "$f" =~ .*\.(desktop) ]]; then
            path="${f##*/}"
            ext="${f##*.}"
            name="${path%.*}"
            [ ! -f "$HOME/Desktop/${name}.${ext}" ] && cp "$f" "$HOME/Desktop/"
        fi
    done
fi

# Add icons
# Icons by Icons8
windows_icons_dir=/usr/share/icons/windows
# sudo mkdir -p "${windows_icons_dir}"

if [[ -d "${assets}/icons/" ]]; then
    for f in "${assets}/icons/*"; do
        if [[ "$f" =~ .*\.(png|svg) ]]; then
            path="${f##*/}"
            ext="${f##*.}"
            name="${path%.*}"
            size="${name##*-}"

            sudo mkdir -p "${windows_icons_dir}/${size}x${size}"
            sudo cp "$f" "${windows_icons_dir}/${size}x${size}/${name}.${ext}"
        fi
    done
fi
#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
repo_root=$( dirname -- "$( dirname -- "$current_dir" )" )
fonts_dir="$repo_root/common/fonts"

mkdir -p "$HOME/.local/share/fonts"

if cp "$fonts_dir"/*.ttf "$HOME/.local/share/fonts/"; then
    echo "Fonts installed successfully"
else
    echo "Font installation failed" >&2
fi

fc-cache -fv

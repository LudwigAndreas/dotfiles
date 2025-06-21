#!/bin/bash

# Usage:
#   ./link-dotfiles.sh shell
#   ./link-dotfiles.sh vim tmux

set -e

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TARGET_DIR="$HOME"

for package in "$@"; do
    echo "Linking package: $package"
    PACKAGE_DIR="$DOTFILES_DIR/$package"

    if [[ ! -d "$PACKAGE_DIR" ]]; then
        echo "ERROR: package directory not found: $PACKAGE_DIR"
        exit 1
    fi

    # For each file or dir inside the package dir
    find "$PACKAGE_DIR" -mindepth 1 -maxdepth 1 | while read src; do
        filename="$(basename "$src")"
        dest="$TARGET_DIR/$filename"

        # If target already exists
        if [[ -e "$dest" || -L "$dest" ]]; then
            echo "Skipping existing: $dest"
        else
            echo "Linking $dest -> $src"
            ln -s "$src" "$dest"
        fi
    done
done

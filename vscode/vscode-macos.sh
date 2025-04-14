#!/bin/bash


configure_vscode() {
    echo "Configuring VSCode"

    # Install settings
    cp settings.json ~/Library/Application\ Support/Code/User/settings.json
    cp keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

    # Install snippets
    cp snippets/* ~/Library/Application\ Support/Code/User/snippets/
}

install_extentions() {
    code --install-extension Catppuccin.catppuccin-vsc
    code --install-extension Catppuccin.catppuccin-vsc-icons
    code --install-extension vscodevim.vim
    code --install-extension esbenp.prettier-vscode
}

update_dotfiles() {
    echo "Updating dotfiles"
    cp ~/Library/Application\ Support/Code/User/settings.json settings.json
    cp ~/Library/Application\ Support/Code/User/keybindings.json keybindings.json
    cp ~/Library/Application\ Support/Code/User/snippets/* snippets/
}

# Check if code is installed
if ! command -v code &> /dev/null; then
    echo "VSCode is not installed"
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --configure)
            configure_vscode
            shift
            ;;
        --install-extentions)
            install_extentions
            shift
            ;;
        --update)
            update_dotfiles
            shift
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done
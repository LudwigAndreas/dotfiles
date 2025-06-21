#!/bin/bash
#
# Basic interactive dotfiles setup script   

cr="$(tput setaf 1)"
cg="$(tput setaf 2)"
cb="$(tput setaf 4)"
cw="$(tput sgr0)"
c0="$(tput init)"

set -e

# Logging functions
function logi {
    printf "%s[*] $1%s\n" "${cw}" "${c0}"
}

function loge {
    printf "%s[-] $1%s\n" "${cr}" "${c0}"
}

function logs {
    printf "%s[+] $1%s\n" "${cg}" "${c0}"
}

function logd {
    [ -n "$verbose" ] && printf "[*] %s$1%s\n" "${cw}" "${c0}"
}

function log {
  logi $1
}

logs "Dotfiles setup"

read -p "[<] Enter your Git user.name: " git_username
read -p "[<] Enter your Git user.email: " git_email

git config --global user.name "${git_username}"
git config --global user.email "${git_email}"

logi ""
logi "Git configuration:"
git config --global --list | grep 'user\.' || echo "(none)"

read -p "[<] Set default git editor (vim/nano/code) [vim]:" git_editor
git_editor=${git_editor:-vim}

git config --global core.editor "${git_editor}"

logi ""
logi "Git git editor set:"
git config --global --list | grep 'core.editor.' || echo "(none)"

logs "Setup complete"

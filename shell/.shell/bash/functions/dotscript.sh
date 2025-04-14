#!/bin/bash

# TODO: fix completion for zsh
# Function to run scripts from your dotfiles directory
dotscript() {
    local scripts_dir="${DOTSCRIPTS_DIR:-$HOME/dotfiles/scripts}"
    
    if [ -z "$1" ]; then
        echo "Usage: dotscript <script-path> [args...]"
        echo "Example: dotscript kubectl/oc-const-port-forward.sh arg1 arg2"
        return 1
    fi
    
    local script_path="$scripts_dir/$1"
    
    if [ ! -f "$script_path" ]; then
        echo "Script not found: $script_path"
        return 1
    fi
    
    # Run the script with all arguments after the first one
    shift
    "$script_path" "$@"
}

# BASH COMPLETION FUNCTION
_dotscript_completions() {
    local scripts_dir="${DOTSCRIPTS_DIR:-$HOME/dotfiles/scripts}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    
    if [ "${COMP_CWORD}" -eq 1 ]; then
        # Find executable scripts and all .sh files
        # local script_list=$(find "${scripts_dir}" -type f 2>/dev/null | sed "s|${scripts_dir}/||")
        local script_list="work history help"
        echo $script_list
        COMPREPLY=( $(compgen -W "${script_list}" -- "${cur}") )
        return 0
    fi
}

# Check if we're in an interactive shell before setting up completion
if [[ $- == *i* ]]; then
    # Register completion for Bash
    if [ -n "$BASH_VERSION" ]; then
        complete -F _dotscript_completions dotscript
    fi
    
    # For Zsh, you'll need to add this to your .zshrc:
    # autoload -Uz compinit && compinit
    # compdef _dotscript_completions dotscript
fi

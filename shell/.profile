if ! command -v source >/dev/null 2>&1; then
    source() {
        . "$@"
    }
fi

umask 022

# Configure default prompt
export PS1='$(whoami)@$(hostname):$(basename $(pwd)) \$ '
export PS2='→ '

# Load bashrc if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Load zshrc if running zsh
if [ -n "$ZSH_VERSION" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi

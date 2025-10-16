
autoload -Uz compinit && compinit

source $HOME/.shell/sh/index.sh
source $HOME/.shell/bash/index-reduced.sh
source $HOME/.shell/zsh/index.sh

fpath+=~/.oh-my-zsh/custom/completions
autoload -U compinit && compinit

_p_completion() {
    local projects_dir="$HOME/vault/projects"
    compadd -- $(find "$projects_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)
}

compdef _p_completion p

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
autoload -Uz compinit && compinit

export ZSH=$HOME/.oh-my-zsh

plugins=(
    git
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

source "$HOME/.shell/config/exports.sh"
source "$HOME/.shell/config/aliases.sh"
source "$HOME/.shell/config/cmd-aliases.sh"
source "$HOME/.shell/config/functions.sh"

_p_completion() {
    local projects_dir="$HOME/vault/projects"
    compadd -- $(find -L "$projects_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)
}

_snippet_completion() {
    local snippets_dir="$XDG_CONFIG_HOME/snippets"
    compadd -- $(find -L "$snippets_dir" -mindepth 1 -maxdepth 1 -type f -exec basename {} \; 2>/dev/null)
}

compdef _p_completion p
compdef _snippet_completion snippet

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

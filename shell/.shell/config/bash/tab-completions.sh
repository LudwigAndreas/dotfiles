# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"
# Include filenames beginning with a "." in the filename expansion.
shopt -s dotglob
# use extended pattern matching features
shopt -s extglob
# match filenames in case-insensitive fashion
shopt -s nocaseglob

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


_p_completion() {
    local projects_dir="$HOME/vault/projects"
    COMPREPLY=($(compgen -W "$(find -L "$projects_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)" -- "${COMP_WORDS[1]}"))
}

_snippet_completion() {
    local snippets_dir="$XDG_CONFIG_HOME/snippets"
    COMPREPLY=($(compgen -W "$(find -L "$snippets_dir" -mindepth 1 -maxdepth 1 -type f -exec basename {} \; 2>/dev/null)" -- "${COMP_WORDS[1]}"))
}

complete -F _p_completion p
complete -F _snippet_completion snippet

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

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


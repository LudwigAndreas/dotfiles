# Only run if interactive shell
[[ $- != *i* ]] && return

# Load system-wide bashrc
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# General configuration
shopt -s checkwinsize # Update window size after every command
# set -o noclobber # prevent file overwrite on stdout redirection
shopt -s nocaseglob; # case-insensitive globbing
shopt -s cdspell; # Autocorrect typos in path names when using `cd`
shopt -s cdable_vars # Define a variable containing a path and you will be able to cd into it

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
fi

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1;
# Extended history configuration
type shopt &> /dev/null && shopt -s histappend # append to history, don't overwrite it
shopt -s cmdhist # Save multi-line commands as one command
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear" # Don't record some commands
# Use standard ISO 8601 timestamp
HISTTIMEFORMAT='%F %T ' # %F=%Y-%m-%d, %T=%H:%M:%S (24-hr format)
bind Space:magic-space # enable history expansion with space
# see http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'


# Input configuration
set bell-style none # Disable beeping and window flashing.
set completion-ignore-case on # Use case-insensitive TAB autocompletion.
set show-all-if-ambiguous off # Auto list TAB completions.
set completion-map-case on # Treat hyphens and underscores as equivalent
set show-all-if-ambiguous on # Display matches for ambiguous patterns at first tab press

source "$HOME/.shell/config/exports.sh"
source "$HOME/.shell/config/aliases.sh"
source "$HOME/.shell/config/cmd-aliases.sh"
source "$HOME/.shell/config/functions.sh"

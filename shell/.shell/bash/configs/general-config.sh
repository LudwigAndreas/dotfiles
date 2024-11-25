# ------------------- general options
shopt -s checkwinsize # Update window size after every command
set -o noclobber # prevent file overwrite on stdout redirection
shopt -s nocaseglob; # case-insensitive globbing
shopt -s cdspell; # Autocorrect typos in path names when using `cd`
shopt -s cdable_vars # Define a variable containing a path and you will be able to cd into it

# fzf stuff
[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

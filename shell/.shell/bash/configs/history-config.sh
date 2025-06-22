# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL="erasedups:ignoreboth" # no duplicate entries
export HISTSIZE=100000 # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE # big big history
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

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias 1="cd -1"
alias 2="cd -2"
alias 3="cd -3"
alias 4="cd -4"
alias 5="cd -5"
alias 6="cd -6"
alias 7="cd -7"
alias 8="cd -8"
alias 9="cd -9"

alias dotfiles="cd $HOME/dotfiles/"
alias dot="cd $HOME/dotfiles/"

{ gls --color -d . >/dev/null 2>&1 && alias ls=gls; }
# List all files colorized in long format
alias l="ls -lahF ${colorflag}"
# List all files colorized in long format, excluding . and ..
alias la="ls -lAhF ${colorflag}"
# List all files colorized and find case insensetive
alias li="ls -lahF ${colorflag} | grep -i"
# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
# List long, sort by mod date, reversed order
alias ltr="ls ${colorflag} -l -t -r"
# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Usual instructions
alias c="clear"
alias h="history"
# Copy with list copied files and prompt before overwriting an existing file
alias cp="cp -iv"
# Alias for directory creation
alias mkdir="mkdir -pv"
alias md="mkdir -p"
# Alias for directory deleting
alias rd="rmdir"
# Aliases for help
alias run-help=man
alias which-command=whence

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# Enable aliases to be sudo’ed
alias _='sudo '

alias hoy="date '+%Y-%m-%d'"
# Get day
alias day='date +%d'

# Get week number
alias week='date +%V'

# Get month
alias month='date +%m'

# IP addresses
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)'"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

alias diskspace_report="df -P -kHl"

alias lowered="tr '[:upper:]' '[:lower:]'"
alias uppered="tr '[:lower:]' '[:upper:]'"

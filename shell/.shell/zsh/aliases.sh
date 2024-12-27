
LS=ls
{ gls --color -d . >/dev/null 2>&1 && LS=gls; }
# List all files colorized in long format
alias l="$LS -lahF ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias la="$LS -lAhF ${colorflag}"

# List only directories
alias lsd="$LS -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command $LS ${colorflag}"

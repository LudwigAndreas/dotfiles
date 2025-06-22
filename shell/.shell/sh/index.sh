
# Load custom executable functions
for function in $HOME/.shell/sh/functions/*; do
    source $function
done

source "$HOME/.shell/sh/exports.sh"
source "$HOME/.shell/sh/path.sh"
source "$HOME/.shell/sh/aliases.sh"
source "$HOME/.shell/sh/configs/prompt-config.sh"

FILE="$HOME/.shell/sh/local.sh" && test -f $FILE && source $FILE
unset FILE

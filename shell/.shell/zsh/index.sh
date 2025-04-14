# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Load custom executable functions
for function in ~/.shell/zsh/functions/*; do
    source $function
done

_load_settings "$HOME/.shell/zsh/configs"

source $HOME/.shell/zsh/exports.sh
source $HOME/.shell/zsh/path.sh
source $HOME/.shell/zsh/aliases.sh
# Local config
FILE="$HOME/.shell/zsh/local.sh" && test -f $FILE && source $FILE
unset FILE


# Load custom executable functions
for function in ~/.shell/bash/functions/*; do
    source $function
done


source $HOME/.shell/bash/exports.sh
source $HOME/.shell/bash/path.sh
source $HOME/.shell/bash/aliases.sh
source $HOME/.shell/bash/configs/general-config.sh
source $HOME/.shell/bash/configs/prompt-config.sh
source $HOME/.shell/bash/configs/input-config.sh
source $HOME/.shell/bash/configs/history-config.sh
source $HOME/.shell/bash/configs/tab-completions.sh

# Local config
FILE="$HOME/.shell/bash/local.sh" && test -f $FILE && source $FILE
unset FILE


# Load custom executable functions
for function in ~/.shell/common/functions/*; do
    source $function
done

source $HOME/.shell/common/exports.sh
source $HOME/.shell/common/path.sh
source $HOME/.shell/common/aliases.sh
FILE="$HOME/.shell/common/local.sh" && test -f $FILE && source $FILE
unset FILE

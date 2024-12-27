# Make vim the default editor.
export VISUAL='vim';
export EDITOR=$VISUAL;
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export KEYTIMEOUT=1
export NVM_DIR="$HOME/.nvm"

# Detect which `ls` flavor is in use
{ ls --version >/dev/null 2>&1; } ||
{ gls --color -d . >/dev/null 2>&1 && ls=gls; } || NONGNU=1 
if [ "$NONGNU" ]; then  # MacOS 'ls'
	colorflag="-G"
  export CLICOLOR=1
	export LSCOLORS='Gxfxcxdxbxegedabagacad'
else # GNU `ls`
	colorflag="--color"
  export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "${method}"="lwp-request -m '${method}'"
done

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

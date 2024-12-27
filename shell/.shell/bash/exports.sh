
# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1;

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

{ ls --version >/dev/null 2>&1; } || { gls --color -d . >/dev/null 2>&1 && ls=gls; } || NONGNU=1 
if [ "$NONGNU" ]; then  # MacOS 'ls'
	colorflag="-G"
  export CLICOLOR=1
	export LSCOLORS='Gxfxcxdxbxegedabagacad'
else # GNU `ls`
	colorflag="--color"
  export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.sh=38;5;124:*.zsh=38;5;124:*.bat=38;5;124:*.BAT=38;5;124:*.bash=38;5;124:*.bin=38;5;124:*.jks=38;5;192;3:*.pem=38;5;192;3:*.der=38;5;192;3:*.p12=38;5;192;3:*.crt=38;5;192;3:*.p12=38;5;192;3:*.pfx=38;5;192;3:*.key=38;5;192;3:*.keytab=38;5;192;3:*.sig=38;5;192;3:*.signature=38;5;192;3:*.enc=38;5;192;3:*id_rsa=38;5;192;3:*id_ecdsa=38;5;192;3:*id_ed25519=38;5;192;3:*.md=38;5;45:*.xml=1;34:*.yml=1;34:*.json=1;34:*.properties=1;34:*.yaml=1;34:*pom.xml=38;5;33:*build.gradle=38;5;33:*Makefile=38;5;33:*.log=38;5;190:*.java=38;5;166:*.coffee=38;5;166:*.jsm=38;5;166:*.jsp=38;5;166:*.jar=38;5;215:*.war=38;5;215:*.apk=38;5;215:*.dmg=38;5;215:*Dockerfile=38;5;111:*.7z=38;5;40:*.7Z=38;5;40:*.bz2=38;5;40:*.rar=38;5;40:*.s7z=38;5;40:*.tar=38;5;40:*.tgz=38;5;40:*.arj=38;5;40:*.taz=38;5;40:*.lzh=38;5;40:*.zip=38;5;40:*.z=38;5;40:*.Z=38;5;40:*.gz=38;5;40:*config=1:*conf=1:*rc=1:*.profile=1:*.bash_profile=1:*.viminfo=1:*.git=38;5;112;4:*.github=38;5;112;4:*.gitignore=38;5;112;4:*.gitattributes=38;5;112;4:*.gitmodules=38;5;112;4:*.tmp=38;5;240:*.swp=38;5;240:*.swo=38;5;240:*.DS_Store=38;5;240:*.bak=38;5;241:*.backup=38;5;241:*.backup=38;5;241:*README=38;5;220;1:*README.rst=38;5;220;1:*README.md=38;5;220;1:*LICENSE=38;5;220;1:*LICENSE.md=38;5;220;1:*COPYING=38;5;220;1:*INSTALL=38;5;220;1:*COPYRIGHT=38;5;220;1:*AUTHORS=38;5;220;1:*HISTORY=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*CONTRIBUTING=38;5;220;1:*CONTRIBUTING.md=38;5;220;1:*CHANGELOG=38;5;220;1:*CHANGELOG.md=38;5;220;1:*CODEOWNERS=38;5;220;1:*PATENTS=38;5;220;1:*VERSION=38;5;220;1:*NOTICE=38;5;220;1:*CHANGES=38;5;220;1'
fi


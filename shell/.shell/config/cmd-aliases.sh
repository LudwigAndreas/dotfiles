
alias v="$EDITOR"
alias vi="$EDITOR"
alias vim="$EDITOR"
alias nvim="$EDITOR"
alias vvim=/usr/bin/vim

if [[ "$EDITOR" == nvim ]]; then
  alias vimdiff='nvim -d'
fi

alias o="open"

alias dopen='/usr/bin/open ~/Downloads/$(ls -t ~/Downloads/ | head -n 1)'


# OS specific aliases
if [[ "$(uname)" == 'Darwin' ]]; then
  alias sleepybear="exec /usr/bin/osascript -e 'tell application "System Events" to sleep'"
else
  alias sleepybear="systemctl suspend"
fi

if command -v pbcopy > /dev/null 2>&1; then
    alias pbcopy=pbcopy
elif command -v xclip > /dev/null 2>&1; then
    alias pbcopy='xclip -selection clipboard'
elif command -v putclip > /dev/null 2>&1; then
    alias pbcopy='putclip'
elif command -v wl-copy > /dev/null 2>&1; then
    alias pbcopy='wl-copy'
else
    alias pbcopy='cat - > /tmp/clipboard'
fi


if command -v pbpaste > /dev/null 2>&1; then
  alias pbpaste='pbpaste'
elif command -v xclip > /dev/null 2>&1; then
  alias pbpaste='xclip -selection clipboard -o'
elif command -v getclip > /dev/null 2>&1; then
  alias pbpaste='getclip'
elif command -v wl-paste > /dev/null 2>&1; then
  alias pbpaste='wl-paste'
elif [[ -e /tmp/clipboard ]]; then
  alias pbpaste='cat /tmp/clipboard'
else
  alias pbpaste='echo ""'
fi

# One of @janmoesen’s ProTip™s
if command -v lwp-request > /dev/null 2>&1; then
    for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	    alias "${method}"="lwp-request -m '${method}'"
    done
fi

if command -v bat > /dev/null 2>&1; then
    alias cat='bat'
fi

# IP addresses
if command -v dig > /dev/null 2>&1; then
    alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
fi

# Git
if command -v git > /dev/null 2>&1; then
    alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
    alias gc="git commit -m"
    alias gca="git commit -a -m"
    alias gp="git push origin HEAD"
    alias gpu="git pull origin"
    alias gst="git status"
    alias gdiff="git diff --no-index --color-words"
    alias gco="git checkout"
    alias gb='git branch'
    alias gba='git branch -a'
    alias gadd='git add'
    alias ga='git add -p'
    alias gcoall='git checkout -- .'
    alias gr='git remote'
fi

# Docker
if command -v docker > /dev/null 2>&1; then
    alias dco="docker compose"
    alias dps="docker ps"
    alias dpa="docker pa -a"
    alias dl="docker ps -l -q"
    alias dx="docker exec -it"
fi

# K8s
if command -v kubectl > /dev/null 2>&1; then
    alias k="kubectl"
    alias ka="kubectl apply -f"
    alias kg="kubectl get"
    alias kd="kubectl describe"
    alias kdel="kubectl delete"
    alias kl="kubectl logs"
    alias kgpo="kubectl get pod"
    alias kgd="kubectl get deployments"
    alias kc="kubectx"
    alias kns="kubens"
    alias kl="kubectl logs -f"
    alias ke="kubectl exec -it"
    alias kcns='kubectl config set-context --current --namespace'
fi

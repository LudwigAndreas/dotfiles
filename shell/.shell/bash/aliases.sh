# Alias for nvim
# alias vim=nvim

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Optional command mapping
# alias cat=bat
alias la=tree

# Git
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker pa -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# K8s
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

if ! command -v pbpaste > /dev/null 2>&1; then
    case "$(uname -s)" in
        Linux)
            if command -v xclip > /dev/null 2>&1; then
                alias pbpaste='xclip -selection clipboard - o'
            elif command -v xsel > /dev/null 2>&1; then
                alias pbpaste='xsel --clipboard --output'
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            if command -v powershell.exe > /dev/null 2>&1; then
                alias pbpaste="powershell.exe -Command Get-Clipboard"
            fi
            ;;
        *)
            ;;
    esac
fi

if ! command -v pbcopy > /dev/null 2>&1; then
    case "$(uname -s)" in
        Linux)
            if command -v xclip > /dev/null 2>&1; then
                alias pbcopy='xclip -selection clipboard'
            elif command -v xsel > /dev/null 2>&1; then
                alias pbcopy='xsel --clipboard --input'
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            if command -v clip > /dev/null 2>&1; then
                alias pbcopy='clip'
            fi
            ;;
        *)
            ;;
    esac
fi

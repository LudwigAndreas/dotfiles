# Shortcuts
alias d="cd ~/Documents/GoogleDrive"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"
alias g="git"

# Alias for nvim
alias vim=nvim

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"


case "$(uname -s)" in
    Linux)
        if command -v xclip > /dev/null 2>&1; then
            alias pbpaste='xclip -selection clipboard - o'
        elif command -v xsel > /dev/null 2>&1; then
            alias pbpaste='xsel --clipboard --output'
        else
            echo "Warning: Neither 'xclip' or 'xsel' is installed."
        fi
        ;;
    CYGWIN*|MINGW*|MSYS*)
        if command -v powershell.exe > /dev/null 2>&1; then
            alias pbpaste="powershell.exe -Command Get-Clipboard"
        else
            echo "Error windows does not support pasting clipboard with command"
        fi
        ;;
    *)
        ;;
esac

case "$(uname -s)" in
    Linux)
        if command -v xclip > /dev/null 2>&1; then
            alias pbopy='xclip -selection clipboard'
        elif command -v xsel > /dev/null 2>&1; then
            alias pbcopy='xsel --clipboard --input'
        else
            echo "Warning: Neither 'xclip' or 'xsel' is installed."
        fi
        ;;
    CYGWIN*|MINGW*|MSYS*)
        if command -v clip > /dev/null 2>&1; then
            alias pbcopy='clip'
        else
            echo "Error: 'clip' command not found."
        fi
        ;;
    *)
        ;;
esac

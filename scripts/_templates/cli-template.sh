cr="$(tput setaf 1)"
cg="$(tput setaf 2)"
cb="$(tput setaf 4)"
cw="$(tput sgr0)"

# Coloring errors
function error {
    printf "%s$1\n" "${cr}"
}

# Logging functions 
function log_info {
    printf "%s[*] $1\n" "${cw}"
}

function log_error {
    printf "%s[-] $1\n" "${cr}"
}

function log_success {
    printf "%s[+] $1\n" "${cg}"
}

function log_debug {
    [ -n "$verbose" ] && printf "[*] %s$1\n" "${cw}"
}

function log {
  log_info $1
}

# Template asking [y]es or [n]o (with case insensetive input)
function ask_yes_no {
    local message=$1
    [ -n "$message" ] && log $message && sleep 1
    printf "%s[*] DO YOU WANT TO PROCEED [Y/N] : " "${cw}"
    while true; do
        read -r install
        # Optional reassignment (only if needed case insensetive parsing)
        install=$(echo "$install" | tr 'a-z' 'A-Z')
        case $install in
            Y|YES)
                return 0
            ;;
            N|NO)
                return 1
            ;;
            *)
                printf "%s[-] Invalid input. Please answer with 'Y[es]' or 'N[o]' [Y/N] : " "${cw}"
                continue
            ;;
        esac
    done
}

# Tempate printing usage
function usage {
    printf %s "${cw}"
    echo "Usage:	$0 [Options]"
    echo
    echo "Options:"
    echo "  -h, --help		Show this help message and exit"
    echo "  -a, --action	Required argument"
    echo "  -f, --file		Optional argument"
    echo "  -v, --verbose	Enable verbose mode"
    printf %s "${cw}"
    exit 0
}

# Template args parser
# help - default help
# verbose - flag argument (only present or not)
# argument - parameterized argument (need to specify action after it)
# file - parameterized argument (need to specify file after it)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    -v|--verbose)
      verbose=true
      shift
      ;;
    -a|--action)
      action="$2"
      shift 2
      ;;
    -f|--file)
      file="$2"
      shift 2
      ;;
    *)
      error "Error: Unknown option $1"
      usage
      ;;
  esac
done


# Check required arguments
if [ -z "$action" ]; then
  error "Error: action is required"
  usage
fi
echo "Action: $action"

# Script
if [ -n "$file" ]; then
  echo "File: $file"
fi

if [ "$verbose" == true ]; then
  echo "Verbose mode enabled"
fi

# Example of usage ask_yes_no
ask_yes_no
if [ $? == 1 ]; then
    log_error "Aborting!"
else
    log_debug "Doing something" 
    sleep 2
    log_success "Successfully finished"
fi

exit 0

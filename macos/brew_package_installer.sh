#!/bin/bash


# Define fancy_echo for logging
fancy_echo() {
  local fmt="$1"; shift

  printf "\\n$fmt\\n" "$@"
}



# Error handler
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT


# Exit on error
set -e


# Ask for the administrator password upfront.
sudo -v

# Keep sudo until script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if OSX Command line tools are installed
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
    test -d "${xpath}" && test -x "${xpath}" ; then
      


  # Create bin directory
  if [ ! -d "$HOME/.bin/" ]; then
    mkdir "$HOME/.bin"
  fi


  # Create .zshrc file
  if [ ! -f "$HOME/.zshrc" ]; then
    touch "$HOME/.zshrc"
  fi


  # Define function to append to .zshrc file
  append_to_zshrc() {
    local text="$1" zshrc
    local skip_new_line="${2:-0}"

    if [ -w "$HOME/.zshrc.local" ]; then
      zshrc="$HOME/.zshrc.local"
    else
      zshrc="$HOME/.zshrc"
    fi

    if ! grep -Fqs "$text" "$zshrc"; then
      if [ "$skip_new_line" -eq 1 ]; then
        printf "%s\\n" "$text" >> "$zshrc"
      else
        printf "\\n%s\\n" "$text" >> "$zshrc"
      fi
    fi
  }


  # Add .bin directory to Path
  append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'


  # Determine Homebrew prefix
  arch="$(uname -m)"
  if [ "$arch" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi


  # Change current shell to zsh
  update_shell() {
    local shell_path;
    shell_path="$(command -v zsh)"

    fancy_echo "Changing your shell to zsh ..."
    if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
      fancy_echo "Adding '$shell_path' to /etc/shells"
      sudo sh -c "echo $shell_path >> /etc/shells"
    fi
    sudo chsh -s "$shell_path" "$USER"
  }

  # Change shell if not zsh
  case "$SHELL" in
    */zsh)
      if [ "$(command -v zsh)" != "$HOMEBREW_PREFIX/bin/zsh" ] ; then
        update_shell
      fi
      ;;
    *)
      update_shell
      ;;
  esac


  # Installs Rosetta if not installed (only for Apple Silicon)
  if [ "$(uname -m)" = "arm64" ]
    then
    # checks if Rosetta is already installed
    if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1
    then
      fancy_echo "Installing Rosetta"
      # Installs Rosetta2
      softwareupdate --install-rosetta --agree-to-license
    else
      fancy_echo "Rosetta is installed"
    fi
  fi


  # Install homebrew if not installed
  if ! command -v brew >/dev/null; then
    fancy_echo "Installing Homebrew ..."
      /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      append_to_zshrc "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\""

      export PATH="$HOMEBREW_PREFIX/bin:$PATH"
  fi


  # Uninstall old Homebrew-Cask
  if brew list | grep -Fq brew-cask; then
    fancy_echo "Uninstalling old Homebrew-Cask ..."
    brew uninstall --force brew-cask
  fi


  # Update Homebrew formulae and tab repositories
  fancy_echo "Updating Homebrew formulae ..."
  brew update --force # https://github.com/Homebrew/brew/issues/1151


  # Define the directory containing Brewfiles
  BREWFILES_DIR="brewfiles"

  # Check if Brewfiles directory exists
  if [ ! -d "$BREWFILES_DIR" ]; then
      fancy_echo "Brewfiles directory not found."
      exit 1
  fi


  # Function to install packages using brew bundle
  install_packages() {
      local brewfile="$1"
      if [ -f "$brewfile" ]; then
          brew bundle --file="$brewfile"
      else
          echo "Brewfile '$brewfile' not found."
      fi
  }


  # Parse command-line arguments
  for arg in "$@"; do
      case "$arg" in
          --network-tools)
              install_packages "$BREWFILES_DIR/network_tools_Brewfile"
              ;;
          --term-utils)
              install_packages "$BREWFILES_DIR/term_utils_Brewfile"
              ;;
          --help)
              echo "Usage: ./install_brew.sh [flags]"
              echo "Flags:"
              echo "  --git: git and git-lfs"
              echo "  --common: Macos utils and common command-line tools"
              echo "  --heroku: Heroku and parity packages"
              echo "  --heroku: Heroku and parity packages"
              echo "  --help: Print this help message"
              exit 0
              ;;
          *)
              echo "Unrecognized flag: $arg"
              exit 1
              ;;
      esac
  done

else
   echo "Need to install the OSX Command Line Tools (or XCode) First! Starting Install..."
   # Install XCODE Command Line Tools
   xcode-select --install
fi
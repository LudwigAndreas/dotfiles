# Dotfiles Repository

This repository contains my personal configuration files (dotfiles) for various tools and applications. These dotfiles are designed to enhance productivity, customize workflows, and maintain consistency across environments.

## Table of Contents

## About

This repository houses configuration files for tools and applications I use daily, such as shell environments, editors, and version control systems. These dotfiles are set up to work seamlessly across multiple devices and operating systems.

This dotfiles repostiroy contains list of directories each for one application:
- git
- intellij
- neofetch
- nvim
- shell
- sshrc
- tmux
- vim
Any of this directories can be symlinked with [GNU Stow](https://www.gnu.org/software/stow/)
## TODO:

- [ ] scripts/kubectl/ restart pod by label
- [ ] scripts/kubectl/ restart pod by habel and port forward
- [ ] scripts/hdfs/ deploy dir with content into hdfs
- [ ] 
- [ ] 
- [ ] 

## Installation

To get started with these dotfiles, you can clone this repository and run [GNU Stow](https://www.gnu.org/software/stow/) on application directory in repository.

```bash
git clone https://github.com/LudwigAndreas/dotfiles
cd dotfiles
stow ${directory}
```

### Prerequisites
- Git
- Stow

## Features
- Split shell configuration structure: separate aliases, functions, promts and exports for sh (the minimum configuration used in most cases for sshrc), bash and zsh.
- Editor Configurations: Settings for Vim, Neovim, VSCode and Intellij
- Version Control: Custom .gitconfig with aliases and settings
- Terminal Tools: Configurations for tools like `tmux`, `fzf`
- Cross-Platform: Designed to work on Macos (Primary), Linux and Windows (WSL and Git Bash)

```bash
dotfiles
├── fonts/                      # Prefered fonts for terminals, IDEs, etc.
├── git/                        # Git configuration
├── intellij/                   # Configuration for Intellij Idea
├── neofetch/                   # Neofetch configuration
├── nvim/                       # NeoVim configuration
├── raycast/                    # Best scripts for raycast
├── scripts/                    # Helper scripts
├── shell/                      # Unified shell configuration
│   ├── .profile                # Bash shell configuration file
│   ├── .bashrc                 # Bash shell configuration file
│   ├── .zshrc                  # Zsh shell configuration file
│   └── .shell/                 # Unified directory for all configuration scripts
│       ├── sh/                 # Directory for sh configuration scripts
│       │   ├─ index.sh         # Index file for loading all config files
│       │   ├─ aliases.sh       # Base aliases 
│       │   ├─ exports.sh       # Base exports
│       │   ├─ path.sh          # Base path extention
│       │   ├─ local.sh         # Local configuration (optional)
│       │   └─ functions/       # Base functions
│       ├── bash/               # Directory for bash configuration scripts
│       │   ├─ index.sh         # Index file for loading all config files
│       │   ├─ aliases.sh       # Bash extended aliases 
│       │   ├─ exports.sh       # Bash extended exports
│       │   ├─ path.sh          # Bash extended path extention
│       │   ├─ local.sh         # Local configuration (optional)
│       │   └─ functions/       # Bash extended functions
│       └── zsh/                # Directory for zsh configuration scripts
│           ├─ index.sh         # Index file for loading all config files
│           ├─ aliases.sh       # Zsh extended aliases 
│           ├─ exports.sh       # Zsh extended exports
│           ├─ path.sh          # Zsh extended path extention
│           ├─ local.sh         # Local configuration (optional)
│           └─ functions/       # Zsh extended functions
├── sshrc/                      # Sshrc configuration 
│   ├── bin/sshrc               # Sshrc executable
│   ├── .sshrc                  # Sshrc configuration
│   └── .sshrc.d/               # Directory containing all configuration files (symlinks)
├── tmux/                       # Tmux configuration
├── vim/                        # Vim configuration
├── vscode/                     # Vscode configuration
├── LICENSE                     # License files
└── README.md                   # This file
```

## Resources
- (ThePrimagen Dotfiles)[https://github.com/ThePrimeagen/.dotfiles]
- (Куда войти Dotfiles)[https://github.com/IlyasYOY/dotfiles]
- (Raycast scripts)[https://github.com/raycast/script-commands/tree/master/commands#browsing]
## Useful tools
- (SDK Installer)[https://sdkman.io/]

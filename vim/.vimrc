" To start vim without using a vimrc file, use: vim -u NORC or -u NONE

syntax on 
filetype plugin on
set nocompatible
highlight LineNr ctermfg=yellow ctermbg=237
au FocusLost * :wa

set termguicolors

silent !mkdir ~/.vim > /dev/null 2>&1
silent !mkdir ~/.vim/backup > /dev/null 2>&1
silent !mkdir ~/.vim/swp > /dev/null 2>&1

set encoding=utf-8

" Leader
let mapleader = " "

set backupdir=~/.vim/backup//
set clipboard=unnamedplus
set directory=~/.vim/swp//
set expandtab
set hlsearch
set ignorecase
set list
set modelines=0
set mouse=a
set mousehide
set noerrorbells
set notimeout
set nu
set number
set path+=**
set relativenumber
set shiftround
set shiftwidth=2
set showcmd
set showmatch
set splitbelow
set splitright
set statusline=%.40F%=%m\ %Y\ Line:\ %3l/%L[%3p%%]
set tabstop=2
set title
set ttyfast
set visualbell
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*.swp,*.bak,*.pyc,*.class
set wildignore+=node_modules/*,bower_components/*
set wildmode=list:longest
set wrap
set colorcolumn=85


let g:netrw_liststyle = 3 " use tree list style
let g:netrw_banner = 0 " get rid of banner at the top
let g:netrw_browse_split = 2 " open files in a new vertical split
let g:netrw_winsize = 25 " width of the explorer pane
nnoremap <Leader><Tab> :Vex " keybinding to open tree

" keybindings here
nnoremap gf :vertical wincmd f<CR>
nnoremap <tab> %
vnoremap <tab> %
let mapleader = ","

" use sane regex handling
nnoremap / /\v
vnoremap / /\v

" make j and k scroll to next line in editor, not next line (in case of wrapped line
nnoremap j gj
nnoremap k gk

" remap navigating panes to ex ctrl-j instead of ctrl-w j
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap ; :
nnoremap <space> zz

""""""""""""""""""
" vim plug stuff "
""""""""""""""""""

" Install vim-plug if it's not already
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Install any uninstalled plugins
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

Plug 'tpope/vim-sensible'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'scrooloose/nerdcommenter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'easymotion/vim-easymotion'
Plug 'bagrat/vim-buffet'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'

" Initialize plugin system
call plug#end()

let g:airline_theme = 'catppuccin_mocha'
colors catppuccin_mocha

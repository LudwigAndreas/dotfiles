" autodownload vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins
call plug#begin()
" default vim parameters
Plug 'tpope/vim-sensible'
" working with paired characters
Plug 'tpope/vim-surround'
" comments in different languages
Plug 'tpope/vim-commentary'
" file tree management
Plug 'scrooloose/nerdtree'
" bundle of fzf-based commands and mappings
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" colorscheme vim-code-dark
Plug 'tomasiser/vim-code-dark'
" icons in vim
Plug 'ryanoasis/vim-devicons'
" icons and hilight in nerdtree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end() 

" set colorscheme
colorscheme codedark
" set colorscheme for airline
let g:airline_theme = 'codedark'

set nu
set expandtab
set relativenumber
set sw=2
set sts=2
set nocompatible
set history=1000
set encoding=UTF-8
set tabstop=4
set shiftwidth=4

filetype on
syntax enable

" set functional keys
imap <F2> <Esc>:w<CR>
map <F2> <Esc>:w<CR>
imap <F3> <Esc>:q!<CR>
map <F3> <Esc>:q!<CR>
imap <F4> <Esc>:wq<CR>
map <F4> <Esc>:wq<CR>
imap <silent> <F5> <Esc>:noh<CR>
map <F5> <Esc>:noh<CR>
imap <F7> <Esc>:%s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
map <F7> <Esc>:%s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
imap <F8> <Esc>:set cursorcolumn<CR>
map <F8> <Esc>:set cursorcolumn<CR>

" set keys 
map <C-p> :NERDTreeToggle<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>




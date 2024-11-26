" To start vim without using a vimrc file, use: vim -u NORC or -u NONE

""" Backup and swap directories -----------------------------------------------
silent !mkdir ~/.vim > /dev/null 2>&1
silent !mkdir ~/.vim/backup > /dev/null 2>&1
silent !mkdir ~/.vim/swp > /dev/null 2>&1


""" Vim defaults --------------------------------------------------------------
au FocusLost * :wa
syntax on 
filetype plugin on
" highlight LineNr ctermfg=yellow ctermbg=237

set encoding=utf-8
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
" Disable defaults
set nocompatible
set noerrorbells
set mousehide
set notimeout
set mouse=a
set path+=**
set modelines=0

set nu
set relativenumber
set clipboard^=unnamed,unnamedplus
set expandtab
set hlsearch
set ignorecase
set list
set shiftround
set shiftwidth=4
set showcmd
set showmatch
set splitbelow
set splitright
" set statusline=%.40F%=%m\ %Y\ Line:\ %3l/%L[%3p%%]
set tabstop=2
set title
set ttyfast
set visualbell
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*.swp,*.bak,*.pyc,*.class
set wildignore+=node_modules/*,bower_components/*
" set wildmode=list:longest
set wrap
" set colorcolumn=85



""" Map leader to space -------------------------------------------------------
let mapleader = " "

""" Basic mappings ------------------------------------------------------------
" map black whole register
noremap \ "_
" paste over without overwriting default register
xnoremap p P

nnoremap <Esc> :nohlsearch<CR>

" make j and k scroll to next line in editor, not next line (in case of wrapped line
nnoremap j gj
nnoremap k gk

" move to the beginning of the next word
" map w [w
" move to the end of the next word
" map e ]w
" move to the beginning of the previous word
" map b [b
" move to the end of the previous word
" map ge ]b
" add new line without entering edit mode
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>


""" Config --------------------------------------------------------------------
noremap <leader>sc :edit ~/.vimrc<CR>
noremap <leader>ss :source ~/.vimrc<CR>

""" Cursor --------------------------------------------------------------------
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
\ if v:insertmode == 'i' | 
\   silent execute '!echo -ne "\e[6 q"' | redraw! |
\ elseif v:insertmode == 'r' |
\   silent execute '!echo -ne "\e[4 q"' | redraw! |
\ endif
au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif


""" Movement between splits ---------------------------------------------------
" nnoremap <C-h> <C-w>h
" Mapping for virtual machine settings
" nnoremap <C-BS> <C-w>h
" nnoremap <C-l> <C-w>l
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k

nnoremap <C-D> <C-d>
nnoremap <C-U> <C-u>


""" Tab/Window/Buffer/Split actions -------------------------------------------
map <leader>wv :vsplit<CR>
map <leader>wh :split<CR>
map <leader>wl <C-W>L
map <leader>wj <C-W>J
map <leader>wk <C-W>K
map <leader>wh <C-W>H
map gn :bnext<CR>
map gp :bprevious<CR>
" map <leader>wm :action MoveEditorToOppositeTabGroup<CR>
map <leader>ww :bdelete<CR>
"map <leader>wa :action UnsplitAll<CR>
" map <C-W> <C-w>o
"map <C-S-W> :q<CR>


""" Tab/Window/Buffer/Split navigation ----------------------------------------
" map <C-TAB> :tabnext<CR>
" map <C-S-TAB> :tabprevious<CR>

" map <leader>tf :tabfirst<CR>
" map <leader>tm :tabmove<CR>
" map <leader>tl :tablast<CR>


""" Plugins -------------------------------------------------------------------

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
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'scrooloose/nerdcommenter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'easymotion/vim-easymotion'
Plug 'bagrat/vim-buffet'
Plug 'ryanoasis/vim-devicons'
" Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'

" Initialize plugin system
call plug#end()


" TmuxNavigator
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 2
nnoremap <C-h> :TmuxNavigateLeft<CR>
" Mapping for virtual machine settings
" nnoremap <C-BS> <C-w>h
nnoremap <C-l> :TmuxNavigateRight<CR>
nnoremap <C-j> :TmuxNavigateDown<CR>
nnoremap <C-k> :TmuxNavigateLeft<CR>

""" File tree navigation ------------------------------------------------------

noremap \ :NERDTreeToggle<CR>


""" Catppuccin theme ----------------------------------------------------------

set termguicolors
colors catppuccin_mocha
let g:airline_theme = 'catppuccin_mocha'
" let g:airline#extensions#branch#enabled     = 1
" let g:airline#extensions#bufferline#enabled = 1
" let g:airline#extensions#capslock#enabled   = 1
" let g:airline#extensions#hunks#enabled      = 1
let g:airline#extensions#tabline#enabled    = 1
let g:airline#extensions#tabline#show_tabs    = 1
" let g:airline#extensions#tabline#fnamemod   = ':t' " Only show filename.
" let g:airline#extensions#undotree#enabled   = 1

""" Search --------------------------------------------------------------------
noremap <leader>fw /\v
noremap <leader>fr :%s/\<<C-r><C-w>\>/







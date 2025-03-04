" To start vim without using a vimrc file, use: vim -u NORC or -u NONE

""" Vim defaults --------------------------------------------------------------
au FocusLost * :wa
syntax on 
filetype plugin on
" highlight LineNr ctermfg=yellow ctermbg=237

set encoding=utf-8
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
set tabstop=2
set title
set ttyfast
set visualbell
set breakindent
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*.swp,*.bak,*.pyc,*.class
set wildignore+=node_modules/*,bower_components/*
set scrolloff=8 
set sidescrolloff=8
set wrap
set updatetime=250
set completeopt=menuone,noselect


""" Map leader to space -------------------------------------------------------
let mapleader = " "

""" Basic mappings ------------------------------------------------------------
" map black whole register
" noremap ~ "_
" Toggle Vexplore with \
nnoremap <C-b> :Lexplore<CR>
let g:netrw_liststyle = 3
let g:netrw_winsize=25
let g:netrw_alto=1

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


""" Movement between splits ---------------------------------------------------
nnoremap <C-h> <C-w>h
" Mapping for virtual machine settings
" nnoremap <C-BS> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

nnoremap <S-E> $
nnoremap <S-B> ^

nnoremap <C-D> <C-d>
nnoremap <C-U> <C-u>


""" Tab/Window/Buffer/Split actions -------------------------------------------
map <leader>wv :vsplit<CR>
map <leader>wh :split<CR>
map <leader>wml <C-W>L
map <leader>wmj <C-W>J
map <leader>wmk <C-W>K
map <leader>wmh <C-W>H
map gn :bnext<CR>
map gp :bprevious<CR>
noremap <C-W> :wq<CR>


""" Tab/Window/Buffer/Split navigation ----------------------------------------

map <leader>tk :blast<CR>
map <leader>tj :bfirst<CR>
map <leader>th :bprev<CR>
map <leader>tl :bnext<CR>
map <leader>td :bdelete<CR>


""" Search --------------------------------------------------------------------
noremap <leader>fw /\v
noremap <leader>fr :%s/\<<C-r><C-w>\>/


""" Default colorscheme -------------------------------------------------------
colorscheme slate
" colorscheme desert
" colorscheme lunaperche

""" Plugins -------------------------------------------------------------------
" util func to source relative
function! SourceLocal(relativePath)
  let root = expand('<sfile>:p:h')
  let fullPath = root . '/'. a:relativePath
  if filereadable(fullPath)
    exec 'source' . fullPath
  endif
endfunction

call SourceLocal (".vimrc-plug")
call SourceLocal (".vimrc-local")

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
" noremap ~ "_
" Toggle Vexplore with \
nnoremap \ :Lexplore<CR>
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
map <leader>wml <C-W>L
map <leader>wmj <C-W>J
map <leader>wmk <C-W>K
map <leader>wmh <C-W>H
map gn :bnext<CR>
map gp :bprevious<CR>
noremap <C-W> :wq<CR>


""" Tab/Window/Buffer/Split navigation ----------------------------------------
map <C-TAB> <C-W>l <CR>
map <C-S-TAB> <C-W>j <CR>
" map <C-S-W> :bdelete<CR>

" map <leader>tf :tabfirst<CR>
" map <leader>tm :tabmove<CR>
" map <leader>tl :tablast<CR>


""" Search --------------------------------------------------------------------
noremap <leader>fw /\v
noremap <leader>fr :%s/\<<C-r><C-w>\>/

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

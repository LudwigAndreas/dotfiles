" To start vim without using a vimrc file, use: vim -u NORC or -u NONE

""" Vim defaults --------------------------------------------------------------
syntax on 
filetype plugin on
filetype plugin indent on

set encoding=utf-8
" highlight current line
set cursorline
:highlight Cursorline cterm=bold ctermbg=black
" highlight LineNr ctermfg=yellow ctermbg=237

" show matching part of pairs [] {} and ()
set showmatch

" enable mouse support
set mouse=a
set mousehide

" Disable defaults
set nocompatible
set noerrorbells
set notimeout
set path+=**
set modelines=0
set list

" use system clipboard
set clipboard=unnamedplus

" enable line numbers
set nu
" use relative numbers
set relativenumber

" enable hightlight search pattern
set hlsearch
" enable smartcase search pattern
set ignorecase
set smartcase

" Indentation using spaces
" tabstop:     width of tab characters
" softtabstop: fine tunes the amount of whitespace to be added
" shiftwidth:  determines the amount of whitespace to add in normal mode
" expandtab:   when on use space instead of tab
" textwidth:   text wrap width
" autoindent:  autoindent in new line
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set autoindent
set expandtab

set shiftround
set smartindent
set showcmd
set splitbelow
set splitright
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

""" Hooks ---------------------------------------------------------------------
au FocusLost * :wa
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

nnoremap <S-E> $
nnoremap <S-B> ^

nnoremap <C-D> <C-d>
nnoremap <C-U> <C-u>


""" Buffer management ---------------------------------------------------------
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :ls<CR>
nnoremap <leader>bb :buffer<CR>

""" Window management ---------------------------------------------------------
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
" Mapping for virtual machine settings
" nnoremap <C-BS> <C-w>h
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <leader>wq <C-w>q
nnoremap <leader>wo <C-w>o

""" Tab management ------------------------------------------------------------
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tp :tabprevious<CR>
nnoremap <leader>tn :tabnext<CR>

""" Search --------------------------------------------------------------------
noremap <leader>fw /\v
noremap <leader>fr :%s/\<<C-r><C-w>\>/


""" Default colorscheme -------------------------------------------------------
" enable color themes
if !has('gui_running')
    set t_Co=256
endif
" enable true colors support
set termguicolors
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

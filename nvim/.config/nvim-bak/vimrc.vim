set sw=2
set sts=2
set nocompatible
set history=10000
set tabstop=4
set shiftwidth=4

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
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

nnoremap <silent> <C-h> <Cmd>NvimTmuxNavigateLeft<CR>
nnoremap <silent> <C-j> <Cmd>NvimTmuxNavigateDown<CR>
nnoremap <silent> <C-k> <Cmd>NvimTmuxNavigateUp<CR>
nnoremap <silent> <C-l> <Cmd>NvimTmuxNavigateRight<CR>
nnoremap <silent> <C-\> <Cmd>NvimTmuxNavigateLastActive<CR>
nnoremap <silent> <C-Space> <Cmd>NvimTmuxNavigateNext<CR>



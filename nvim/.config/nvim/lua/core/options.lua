-------------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local home = os.getenv("HOME")
local g = vim.g
local opt = vim.opt
local opt_global = vim.opt_global

-- disable language provider support (use lua and vimscript plugins only)
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

-- disable unused stuff
g.loaded = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_matchit = 1 -- use vim-matchup
g.loaded_matchparen = 1 -- use vim-matchup

-- basic settings
vim.cmd("filetype plugin on")
g.completeopt = { "menuone", "noinsert", "noselect" }
opt_global.shortmess:remove("F")
opt.encoding = "utf-8"
opt.backspace = "indent,eol,start" -- backspace works on every char in insert mode
opt.history = 1000
opt.startofline = true
opt.clipboard = "unnamedplus"
opt.textwidth = 73

-- wait time
-- opt.timeout = false
opt.timeoutlen = 300
opt.ttimeout = true
opt.ttimeoutlen = 100

-- display
opt.showmatch = true -- show matching brackets
opt.scrolloff = 3 -- always show 3 rows from edge of the screen
opt.synmaxcol = 300 -- stop syntax highlight after x lines for performance
opt.laststatus = 2 -- always show status line

opt.list = false -- do not display white characters
opt.foldenable = false
opt.foldlevel = 4 -- limit folding to 4 levels
opt.foldmethod = "syntax" -- use language syntax to generate folds
opt.wrap = false --do not wrap lines even if very long
opt.eol = false -- show if there's no eol char
opt.showbreak = "↪" -- character to show when line is broken

opt.termguicolors = true

-- opt.showmode = false
opt.ruler = false
opt.shortmess:append("asIF")
opt.cmdheight = 0

-- sidebar
opt.number = true -- line number on the left
opt.numberwidth = 3 -- always reserve 3 spaces for line number
opt.signcolumn = "yes" -- keep 1 column for coc.vim  check
opt.modelines = 0
opt.showcmd = true -- display command in bottom bar

-- search
opt.incsearch = true -- starts searching as soon as typing, without enter needed
opt.ignorecase = true -- ignore letter case when searching
opt.smartcase = true -- case insentive unless capitals used in search

-- backup and undo
opt.backup = true
opt.swapfile = false
opt.backupdir = home .. "/.config/nvim/.backup/"
opt.directory = home .. "/.config/nvim/.swp/"
opt.undodir = home .. "/.config/nvim/.undo/"
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000

-- text format
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.cindent = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true -- expand tab to spaces
opt.smarttab = true

vim.g.mapleader = " "

vim.g.guicursor = "n-v-c:block,i-ci-ve:ver25"

vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
-- vim.opt.winborder = "rounded"

vim.opt.clipboard:append("unnamedplus")

vim.opt.spell = true
-- vim.opt.spelllang = { 'en', 'ru' }
vim.opt.spelllang = { "en" }

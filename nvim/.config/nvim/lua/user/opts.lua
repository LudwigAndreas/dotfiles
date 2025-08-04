vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
-- vim.g.netrw_browse_split = 4
-- vim.g.netrw_keepdir = 0
-- vim.g.netrw_cursor = 1


vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.showmatch = true
vim.opt.mousehide = true

vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.timeout = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.hlsearch = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Configure how new splits should be opened
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 79

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true

vim.opt.shiftround = true
vim.opt.showcmd = true


vim.opt.title = true
vim.opt.ttyfast = true

-- Enable break indent
vim.opt.breakindent = true

vim.opt.wildignore:append {
    "*.bmp","*.gif","*.ico","*.jpg","*.png","*.pdf","*.psd",
    "*.swp","*.bak","*.pyc","*.class","node_modules/*","bower_components/*"
}

-- Save undo history
vim.opt.undofile = true
vim.opt.wrap = false

vim.opt.termguicolors = true

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Autosave on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "wa",
})

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Ecs>", "<cmd>nohlsearch<CR>", { noremap = true })

map("n", "<leader>pv", vim.cmd.Ex)

-- Keybinds to make split navigation easier (with tmuxNavigator)
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map("n", "<C-b>", ":Lexplore<CR>", { noremap = true})

-- map("x", "p", "P", { noremap = true })


map("n", "j", "gj", { noremap = true })
map("n", "k", "gk", { noremap = true })

map("n", "<leader>o", "o<Esc>", { noremap = true })
map("n", "<leader>O", "O<Esc>", { noremap = true })

map("n", "<S-E>", "$", { noremap = true })
map("n", "<S-B>", "^", { noremap = true })
map("n", "<C-D>", "<C-d>", { noremap = true })
map("n", "<C-U>", "<C-u>", { noremap = true })

map("n", "<leader>bn", ":bnext<CR>", { noremap = true })
map("n", "<leader>bp", ":bprev<CR>", { noremap = true })
map("n", "<leader>bc", ":bdelete<CR>", { noremap = true })
-- map("n", "<leader>bl", ":ls<CR>", { noremap = true })
map("n", "<leader>bb", ":buffer<CR>", { noremap = true })

map("n", "<leader>sv", ":vsplit<CR>", { noremap = true })
map("n", "<leader>sh", ":split<CR>", { noremap = true })
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<leader>wq", "<C-w>q", { noremap = true })
map("n", "<leader>wo", "<C-w>o", { noremap = true })

map("n", "<leader>tw", ":tabnew<CR>", { noremap = true })
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
map("n", "<leader>to", ":tabonly<CR>", { noremap = true })
map("n", "<leader>tp", ":tabprevious<CR>", { noremap = true })
map("n", "<leader>tn", ":tabnext<CR>", { noremap = true })

map("n", "<leader>oa", "gg=G", { noremap = true })

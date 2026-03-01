-----------------------------------------------------------
-- Autocommand functions
-----------------------------------------------------------
---
---
local map = require("config.utils").map

local bufopts = { silent = true, noremap = true }

map("v", "<C-c>", '"+y', bufopts, "Yank into system clipboard")
map({ "n", "v" }, "<leader>y", [["+y]], bufopts, "Yank into system clipboard")
map("n", "<leader>Y", [["+Y]], bufopts, "Yank line into system clipboard")

map("n", "<C-p>", '"+p', bufopts, "Paste from system clipboard")
map("i", "<C-p>", "<C-r>+", bufopts, "Paste from system clipboard")
map("x", "<leader>p", [["_dP]], bufopts, "Paste witout replacing clipboard")

map("n", "<Esc>", "<cmd>nohlsearch<CR>", bufopts, "Disable highlight on Esc")

-- Remapping for defaults
map("n", "J", "mzJ`z", bufopts, "Join line without moving cursor")

map("n", "<C-d>", "<C-d>zz", bufopts, "Move half screed down with centered cursor")
map("n", "<C-u>", "<C-u>zz", bufopts, "Move half screed up with centered cursor")

map("n", "n", "nzzzv", bufopts, "Go to next search match and unfold if needed")
map("n", "N", "Nzzzv", bufopts, "Go to next search match and unfold if needed")

map("v", "J", ":m '>+1<CR>gv=gv", bufopts, "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", bufopts, "Move selection up")

map("n", "<Tab>", "ma=ap'a", bufopts, "Indent current paragraph")
map("v", "<Tab>", "=gv", bufopts, "Indent selection")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], bufopts, "Replace current word")
map("x", "<leader>s", [["sy:%s/<C-r>s//gI<Left><Left><Left>]], bufopts, "Replace selection")

map("n", "<leader>fc", ":e $MYVIMRC<CR>", bufopts, "[F]ind nvim [C]onfiguration")

map("n", "<leader>c", "ma1z=`a", bufopts, "Smart word syntax fix")

-- window management
map("n", "<C-S-Right>", "<cmd>:vertical resize -2<cr>", bufopts, "Resize window right")
map("n", "<C-S-Left>", "<cmd>:vertical resize +2<cr>", bufopts, "Resize window left")
map("n", "<C-S-Down>", "<cmd>:resize -2<cr>", bufopts, "Resize window down")
map("n", "<C-S-Up>", "<cmd>:resize +2<cr>", bufopts, "Resize window up")

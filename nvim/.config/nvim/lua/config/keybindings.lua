local map = vim.keymap.set

-- Remapping for defaults
map("n", "J", "mzJ`z",
    { desc = "Join line without moving cursor" }
)

map("n", "<C-d>", "<C-d>zz",
    { desc = "Move half screed down with centered cursor" }
)
map("n", "<C-u>", "<C-u>zz",
    { desc = "Move half screed up with centered cursor" }
)

map("n", "n", "nzzzv",
    { desc = "Go to next search match and unfold if needed" }
)
map("n", "N", "Nzzzv",
    { desc = "Go to next search match and unfold if needed" }
)

-- Custom mappings
-- map("n", "\\", ":Lexplore<CR>")

-- map("n", "<leader>f.", ":Lexplore %:p:h<CR>")

map("v", "J", ":m '>+1<CR>gv=gv",
    { desc = "Move selection down" }
)
map("v", "K", ":m '<-2<CR>gv=gv",
    { desc = "Move selection down" }
)

map("n", "=ap", "ma=ap'a",
    { desc = "Intent current paragraph" }
)


map("x", "<leader>p", [["_dP]])

map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
    { desc = "Replace current word" }
)

map("x", "<leader>s", [["sy:%s/<C-r>s//gI<Left><Left><Left>]],
    { desc = "Replace selection" }
)

map("n", "<Esc>", ":noh<CR>")
map("n", "<leader>fc", ":e $MYVIMRC<CR>",
    { desc = "[F]ind my nvim [C]onfiguration" }
)

-- TODO: may not work
map("n", "<leader>rc", ":source $MYVIMRC<CR>",
    { desc = "[R]eload [C]onfiguration" }
)

map({ "n", "v" }, "<leader>c", "1z=")

-- LSP
map('n', "<leader>oa", vim.lsp.buf.format)

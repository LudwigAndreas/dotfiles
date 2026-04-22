local map = require("config.utils").map

local bufopts = { silent = true, noremap = true }

-- ": - command buffer
-- ":p - print command buffer
-- @: - repeat last executed command

-- "= - expression register
-- "=strftime("%c")<cr>p - paste "Mon Mar  2 20:05:49 2026"

-- m{letter} - set mark on cursor
-- '{letter} - go to mark

map("n", "<C-A>", "<C-A>", bufopts, "Increase number under cursor")
map("n", "<C-X>", "<C-X>", bufopts, "Decrease number under cursor")

map("n", "q:", "q:", bufopts, "Open command history")

map("n", "gv", "gv", bufopts, "Goto last selection")

map("n", "v_o", "v_o", bufopts, "Goto other visual selection block")

map("n", "g<C-A>", "g<C-A>", bufopts, "Increase number according to string")
map("n", "g<C-X>", "g<C-X>", bufopts, "Decrease number according to string")

-- https://habr.com/ru/articles/454742/

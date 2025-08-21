return { 
    "echasnovski/mini.pick",
    name = "mini.pick",
    version = "*",
    enable = false, -- use telescope
    keys = {
        {"<leader>ff", ":Pick files<CR>", desc = "[F]ind [F]iles"},
        {"<leader>fg", ":Pick grep_live<CR>", desc = "[F]ind [G]rep"},
        {"<leader>fh", ":Pick help<CR>", desc = "[F]ind [H]elp"},
    },
    config = function()
        require("mini.pick").setup()
    end,
}


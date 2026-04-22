return {
    "nvimdev/template.nvim",
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
        require("template").setup({
            temp_dir = vim.fn.expand("~/vault/work/templates"),
            author = 'LudwigAndreas',
            email = 'ev.sand.raw@gmail.com',
        })
        require('telescope').load_extension('find_template')
        vim.keymap.set('n', '<leader>ft', ':Telescope find_template<cr>', { desc = '[F]ind [T]emplate' })
    end,
}

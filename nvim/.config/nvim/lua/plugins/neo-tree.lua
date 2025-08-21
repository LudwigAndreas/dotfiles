return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
      --      { "\\",         ":Neotree filesystem toggle<CR>", desc = "Toggle filetree" },
      { "<leader>gt", ":Neotree git_status<CR>", desc = "[G]ind status [T]ree" },
      { "<leader>f.", ":Neotree reveal<CR>",     desc = "[F]ind current file in filetree" },
    },
    config = function()
      require('neo-tree').setup({
        source_selector = {
          winbar = true,
          statusline = false,
        }
      })

      vim.keymap.set("n", "\\",
        function()
          if vim.bo.filetype == "neo-tree" then
            -- If already inside Neo-tree → close it
            vim.cmd("Neotree close")
          else
            local manager = require("neo-tree.sources.manager")
            local state = manager.get_state("filesystem")
            if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
              -- If Neo-tree is open → focus it
              vim.cmd("Neotree focus")
            else
              -- Otherwise open it
              vim.cmd("Neotree reveal filesystem left")
            end
          end
        end, { desc = "Smart toggle filetree" })
    end,
  }
}

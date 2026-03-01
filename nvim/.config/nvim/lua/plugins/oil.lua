return {
  {
    "refractalize/oil-git-status.nvim",
    enabled = false,
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = function()
      require('oil-git-status').setup({
        show_ignored = true,
        symbols = {
          index = {
            ["!"] = "!",
            ["?"] = "?",
            ["A"] = "A",
            ["C"] = "C",
            ["D"] = "D",
            ["M"] = "L",
            ["R"] = "R",
            ["T"] = "T",
            ["U"] = "U",
            [" "] = " ",
          },
          working_tree = {
            ["!"] = "!",
            ["?"] = "?",
            ["A"] = "A",
            ["C"] = "C",
            ["D"] = "D",
            ["M"] = "M",
            ["R"] = "R",
            ["T"] = "T",
            ["U"] = "U",
            [" "] = " ",
          },
        },
      })
    end,
  },
  {
    'stevearc/oil.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    enabled = false,
    lazy = false,
    opts = {
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
      },
      float = {
        padding = 2,
        max_width = 40,
        max_height = 0,
        border = "rounded",
      },
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      restore_win_options = true,
      use_default_keymaps = true,
      keymaps = {
        ["<CR>"] = "actions.select",
        ["J"] = "actions.select",
        ["K"] = "actions.parent",
        ["<BS>"] = "actions.parent",
        ["<C-p>"] = "actions.preview",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      vim.keymap.set("n", "\\", function()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        local ft = vim.bo.filetype

        if ft == "oil" then
          if #wins <= 1 then
            vim.notify("This is only window", vim.log.levels.WARN)
            return
          end
          vim.cmd("close")
          return
        end

        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "oil" then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
        vim.cmd("vsplit | vertical resize 35")
        require('oil').open()
      end, { desc = "Open file tree" })
    end
  },
}

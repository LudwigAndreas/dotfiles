return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },

  opts = {
    workspaces = {
      {
        name = "work",
        path = "~/vault/work",
      },
    },

    notes_subdir = "inbox",

    new_notes_location = "notes_subdir",

    preferred_link_style = "wiki",

    disable_frontmatter = true,

    note_id_func = function(title)
      if title ~= nil then
        return title
          :lower()
          :gsub("[^a-z0-9- ]", "") -- remove special chars
          :gsub(" ", "-")
      else
        return tostring(os.time())
      end
    end,

    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "daily.md",
    },

    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",

      substitutions = {
        title = function()
          return vim.fn.expand("%:t:r")
        end,
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    picker = {
      name = "telescope.nvim",
    },
    mappings = {

      -- Smart action for gf
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = {
          noremap = false,
          expr = true,
          buffer = true,
          desc = "Obsidian follow link",
        },
      },

      -- Follow wiki links
      ["<CR>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = {
          buffer = true,
          expr = true,
          desc = "Smart action",
        },
      },

    },
  },
}

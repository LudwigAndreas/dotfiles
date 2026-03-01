return {
	"nvim-tree/nvim-web-devicons",
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			local C = require("catppuccin.palettes").get_palette("mocha")
			require("catppuccin").setup({
				integrations = {
					cmp = true,
					telescope = {
						enabled = true,
					},
					which_key = true,
					lualine = {
						normal = {
							a = { bg = C.blue, fg = C.mantle, gui = "bold" },
							b = { bg = C.surface0, fg = C.blue },
							c = { bg = transparent_bg, fg = C.text },
						},

						insert = {
							a = { bg = C.green, fg = C.base, gui = "bold" },
							b = { bg = C.surface0, fg = C.green },
						},

						terminal = {
							a = { bg = C.green, fg = C.base, gui = "bold" },
							b = { bg = C.surface0, fg = C.green },
						},

						command = {
							a = { bg = C.peach, fg = C.base, gui = "bold" },
							b = { bg = C.surface0, fg = C.peach },
						},
						visual = {
							a = { bg = C.mauve, fg = C.base, gui = "bold" },
							b = { bg = C.surface0, fg = C.mauve },
						},
						replace = {
							a = { bg = C.red, fg = C.base, gui = "bold" },
							b = { bg = C.surface0, fg = C.red },
						},
						inactive = {
							a = { bg = transparent_bg, fg = C.blue },
							b = { bg = transparent_bg, fg = C.surface1, gui = "bold" },
							c = { bg = transparent_bg, fg = C.overlay0 },
						},
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"catppuccin",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = "|",
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "dashboard" } },
				},
				sections = {
					lualine_a = { { "mode", right_padding = 2 } },
					lualine_b = {
						{ "filetype", icon_only = true, colored = true },
						{ "filename" },
						{ "branch", icon = "", color = { fg = "#c296eb", gui = "bold" } },
					},
					lualine_c = { "diff", "diagnostics" },
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { { "location", left_padding = 2 } },
				},
			})
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}

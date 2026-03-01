return {
	{
		"williamboman/mason.nvim", -- manson package manager
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- manson packages installer
		opts = {
			ensure_installed = {
				"prettier", -- JSON, JS, YAML
				"xmlformatter", -- XML
				"stylua", -- Lua
			},
		},
	},
	{
		"stevearc/conform.nvim", -- run style-formatter
		events = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					json = { "prettierd", "prettier", "fixjson", stop_after_first = true },
					xml = { "xmlformatter" },
					yaml = { "prettier" },
					lua = { "stylua" },
					javascript = { "prettier" },
				},
			})
			vim.keymap.set("n", "<leader>oi", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format buffer" })
		end,
	},
}

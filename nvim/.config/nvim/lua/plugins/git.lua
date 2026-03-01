return {
	"tpope/vim-fugitive", -- add :Git commands
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
				view = {
					merge_tool = {
						layout = "diff3_horizontal",
						disable_diagnostics = true,
					},
				},
				keymaps = {
					view = {
						{ "n", "<leader>gcl", "actions.conflict_choose('ours')", { desc = "Accept local" } },
						{ "n", "<leader>gcr", "actions.conflict_choose('theirs')", { desc = "Accept remote" } },
						{ "n", "<leader>gcb", "actions.conflict_choose('base')", { desc = "Accept bASE" } },
						{ "n", "<leader>gca", "actions.conflict_choose('all')", { desc = "Accept everything" } },
						{ "n", "<leader>gcx", "actions.conflict_choose('none')", { desc = "Accept none (remove)" } },
					},
				},
			})
		end,
	},
}

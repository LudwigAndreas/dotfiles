return {
	{
		"Wansmer/langmapper.nvim",
		lazy = false,
		priority = 1, -- High priority is needed if you will use `autoremap()`
		config = function()
			require("langmapper").setup({

			})
		end,
	},
	{
		"mrsobakin/multilayout.nvim",
		opts = {
			layouts = {
				ru = "ru",
			},
			-- Enable if you want to have full multilayout.nvim functionality.
			use_libukb = false,
		},
	},
}

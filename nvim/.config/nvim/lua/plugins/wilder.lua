return {
	"gelguy/wilder.nvim", -- help with vim commands
	enabled = false,
	config = function()
		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })

		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				highlights = {
					border = "FloatBorder", -- Использует цвета темы Catppuccin
				},
				border = "rounded", -- попробуйте сменить на "single" или "none"
				left = { " ", wilder.popupmenu_devicons() }, -- иконки файлов
				right = { " ", wilder.popupmenu_scrollbar() }, -- полоса прокрутки
			}))
		)
	end,
}

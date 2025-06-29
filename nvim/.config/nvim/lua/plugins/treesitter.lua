return {
	"nvim-treesitter/nvim-treesitter",
	name = 'treesitter',
	branch = 'master',
	lazy = false,
	build = ":TSUpdate",
	main = 'nvim-treesitter.configs',
	opts = {
		ensure_installed = { 
			"bash",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"java",
			"javascript",
		},
		sync_install = false,
		auto_install = true,
		indent = { enable = true, disable = { 'ruby' } },
		highlight = {
			enable = true,
			disable = function(lang, buf)
				local max_filesize = 1000 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},
	}
}

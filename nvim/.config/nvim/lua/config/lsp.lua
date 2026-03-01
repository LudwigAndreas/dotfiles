-- LSP Configuration
local remap = require("config.utils").map

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	remap("n", "gD", vim.lsp.buf.declaration, bufopts, "Go to declaration")
	remap("n", "gd", vim.lsp.buf.definition, bufopts, "Go to definition")
	remap("n", "gi", vim.lsp.buf.implementation, bufopts, "Go to implementation")
	remap("n", "gt", vim.lsp.buf.type_definition, bufopts, "Go to type definition")
	remap("n", "K", vim.lsp.buf.hover, bufopts, "Hover text")
	remap("n", "<C-q>", vim.lsp.buf.signature_help, bufopts, "Show signature")
	-- remap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
	-- remap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
	-- remap('n', '<leader>wl', function()
	--   print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
	-- end, bufopts, "List workleader folders")
	remap("n", "<leader>rn", vim.lsp.buf.rename, bufopts, "Rename")
	remap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts, "Code actions")
	vim.keymap.set(
		"v",
		"<leader>ca",
		"<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
		{ noremap = true, silent = true, buffer = bufnr, desc = "Code actions" }
	)
	remap("n", "<leader>oa", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts, "Format file")
end

-- add completion capability
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config("ltex", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc" },
	settings = {
		ltex = {
			language = "en-CA",
		},
	},
})

vim.lsp.config("gopls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

vim.lsp.config("pyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		pyright = {
			analysis = {
				useLibraryCodeForTypes = true,
			},
		},
	},
})

vim.lsp.config("rust_analyzer", {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

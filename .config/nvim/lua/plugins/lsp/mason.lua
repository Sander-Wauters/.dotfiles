return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local masonLspconfig = require("mason-lspconfig")

		mason.setup()
		masonLspconfig.setup({
			ensure_installed = {
				"clangd",
				"cssls",
				"html",
				"jdtls",
				"jedi_language_server",
				"lua_ls",
				"stylua",
				"ts_ls",
			},
			automatic_installation = true,
		})
	end,
}

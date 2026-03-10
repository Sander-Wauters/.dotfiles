return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local masonLspconfig = require("mason-lspconfig")
		local masonToolInstaller = require("mason-tool-installer")

		mason.setup()
		masonLspconfig.setup({
			ensure_installed = {
				"clangd",
				"cssls",
				"html",
				"jdtls",
				"jedi_language_server",
				"lua_ls",
				"tailwindcss",
				"ts_ls",
			},
			automatic_installation = true,
		})
		masonToolInstaller.setup({
			ensure_installed = {
				"eslint_d",
				"prettier",
				"prettierd",
				"stylua",
			},
			automatic_installation = true,
		})
	end,
}

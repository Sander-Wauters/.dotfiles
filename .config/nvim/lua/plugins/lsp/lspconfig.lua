return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	config = function()
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		local lspconfig = require("lspconfig")
		local cmpNvimLsp = require("cmp_nvim_lsp")

		local map = vim.keymap.set

		local opts = { noremap = true, silent = true }
		local onAttach = function(client, bufnr)
			opts.buffer = bufnr

			opts.desc = "Show LSP references"
			map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Go to declaration"
			map("n", "gD", vim.lsp.buf.declaration, opts)

			opts.desc = "Show LSP definitions"
			map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

			opts.desc = "Show LSP implementations"
			map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

			opts.desc = "Show LSP type definitions"
			map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

			opts.desc = "Show available code actions"
			map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

			opts.desc = "Smart rename"
			map("n", "<leader>rn", vim.lsp.buf.rename, opts)

			opts.desc = "Show buffer diagnostics"
			map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

			opts.desc = "Show documentation for what is under cursor"
			map("n", "K", vim.lsp.buf.hover, opts)

			opts.desc = "Restart LSP"
			map("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
		end

		local capabilities = cmpNvimLsp.default_capabilities()

		-- cpp
		lspconfig.clangd.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- css
		lspconfig.cssls.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- html
		lspconfig.html.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- java
		lspconfig.jdtls.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- javascript && typescript
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- angular
		lspconfig.angularls.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- lua
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = onAttach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- cmake
		lspconfig.cmake.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- python
		lspconfig.jedi_language_server.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- gradle
		lspconfig.gradle_ls.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- latex
		lspconfig.ltex.setup({
			capabilities = capabilities,
			on_attach = onAttach,
		})
	end,
}

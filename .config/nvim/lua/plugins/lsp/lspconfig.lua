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
		vim.lsp.config("clangd", {
			capabilities = capabilities,
			on_attach = onAttach,
			cmd = {
				"clangd",
				"--compile-commands-dir=build",
			},
		})

		-- css
		vim.lsp.config("cssls", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- html
		vim.lsp.config("html", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- java
		vim.lsp.config("jdtls", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- javascript && typescript
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- angular
		vim.lsp.config("angularls", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- lua
		vim.lsp.config("lua_ls", {
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
		vim.lsp.config("cmake", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- python
		vim.lsp.config("jedi_language_server", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- gradle
		vim.lsp.config("gradle_ls", {
			capabilities = capabilities,
			on_attach = onAttach,
		})

		-- latex
		vim.lsp.config("ltex", {
			capabilities = capabilities,
			on_attach = onAttach,
		})
	end,
}

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- Odinfmt gets its configuration from odinfmt.json. It defaults
		-- writing to stdout but needs to be told to read from stdin.
		formatters = {
			odinfmt = {
				-- Change where to find the command if it isn't in your path.
				command = vim.fn.stdpath("data") .. "/mason/packages/ols/odinfmt-x86_64-unknown-linux-gnu",
				args = { "-stdin" },
				stdin = true,
			},
		},
		formatters_by_ft = {
			odin = { "odinfmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			graphql = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			lua = { "stylua" },
			latex = { "latexindent" },
			c = nil,
		},
		format_on_save = {
			lsp_format = "never",
			async = false,
			timeout_ms = 500,
		},
	},
}

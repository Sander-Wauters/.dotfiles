return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"python",
			"cpp",
			"css",
			"html",
			"java",
			"jsdoc",
			"json",
			"javascript",
			"typescript",
			"c",
			"lua",
			"odin",
			"json5",
			"vim",
			"vimdoc",
			"query",
			"hlsl",
			"cmake",
			"markdown",
			"glsl",
		},
		indent = {
			enable = true,
			disable = { "cpp" },
		},
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	},
	config = function(_, opts)
		require("nvim-treesitter").install(opts.ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}

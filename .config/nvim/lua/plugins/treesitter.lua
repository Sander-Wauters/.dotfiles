return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	init = function()
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.hlsl = {
			install_info = {
				url = "https://github.com/theHamsta/tree-sitter-hlsl",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "hlsl",
		}
	end,
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
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
}

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = function()
		vim.g.loaded = 1
		vim.g.loaded_netrwPlugin = 1
		vim.keymap.set("n", "<C-n>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle the file explorer" })
	end,
}

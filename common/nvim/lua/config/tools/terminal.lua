local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
require("FTerm").setup({
	blend = 5,
	dimensions = {
		height = 0.90,
		width = 0.90,
		x = 0.5,
		y = 0.5,
	},
})

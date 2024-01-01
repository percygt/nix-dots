local wk = require("which-key")
wk.setup({
	key_labels = {
		["<leader>"] = "Space",
		["ñ"] = "Meta",
	},
	icons = {
		breadcrumb = ">>", -- symbol used in the command line area that shows your active key combo
	},
	window = {
		border = "single",
		padding = { 2, 2, 2, 2 },
	},
	triggers_blacklist = {

		n = { "v", "Q", "q" },
	},
	layout = {
		spacing = 2,
		align = "center",
	},
})

wk.register({
	s = { name = "Search" },
	g = { name = "Git" },
	m = { name = "Misc" },
	d = { name = "Document" },
	h = { name = "Hunk" },
	e = { name = "File Explorer" },
}, { prefix = "<leader>" })

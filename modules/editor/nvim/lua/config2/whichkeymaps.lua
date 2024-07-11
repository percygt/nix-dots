local wk = require("which-key")
local builtin = require("telescope.builtin")

wk.register({
	d = "which_key_ignore",
	h = {
		name = "Helper",
		r = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Multi Replace" },
		x = { "<cmd>!chmod +x %<cr>", "Make executable" },
	},
	t = { name = "Theme" },
	x = {
		name = "Trouble",
		q = { "<cmd>TroubleToggle quickfix<cr>", "Toggle Quickfix List" },
		l = { "<cmd>TroubleToggle loclist<cr>", "Toggle Loclist" },
		x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Toggle Workspace Diagnostic" },
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Toggle Document Diagnostic" },
		r = { "<cmd>TroubleRefresh<cr>", "Refresh" },
	},
	y = "which_key_ignore",
	Y = "which_key_ignore",
	["/"] = "which_key_ignore",
	["?"] = "which_key_ignore",
	["<tab>"] = { name = "Session" },
	["<space>"] = { "<cmd>NoiceDismiss<cr>", "Noice Dismiss" },
}, { prefix = "<leader>", mode = "n", silent = true })

return {
	{
		"folke/which-key.nvim",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			local wk = require("which-key")
			wk.setup({
				window = {
					border = "single",
					padding = { 0, 2, 2, 0 },
				},
				triggers_blacklist = {
					n = { "<C-w>", "v", "Q", "W", "s", "," },
					i = { "<C-w>", "W", "j" },
				},
				layout = {
					align = "center",
					winblend = 100,
				},
			})
			wk.register({
				d = "which_key_ignore",
				h = {
					name = "Helper",
					r = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Multi Replace" },
					x = { "<cmd>!chmod +x %<cr>", "Make executable" },
				},
				y = "which_key_ignore",
				Y = "which_key_ignore",
				["/"] = "which_key_ignore",
				["?"] = "which_key_ignore",
			}, { prefix = "<leader>", mode = "n" })
		end,
	},
}

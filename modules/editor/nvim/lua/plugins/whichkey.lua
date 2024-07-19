return {
	{
		"folke/which-key.nvim",
		lazy = false,
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			win = {
				border = "single",
			},
			layout = {
				align = "center",
			},
			triggers = {
				{ "<auto>", mode = "nixsotc" },
				{ "a", mode = { "n", "v" } },
			},
			icons = {},
			spec = {
				{ "W", hidden = true },
				{ "Q", hidden = true },
				{ "<leader>p", [["_dP]], mode = "x" },
				{ "<leader>h", group = "Helper" },
				{ "<leader>hr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", desc = "Multi Replace" },
				{ "<leader>hx", "<cmd>!chmod +x %<cr>", desc = "Make executable" },
				{ "<leader>/", hidden = true },
				{ "<leader>?", hidden = true },
				{ "<leader>Y", hidden = true },
				{ "<leader>y", hidden = true },
				{ "<leader>p", hidden = true },
				{ "<leader>d", hidden = true },
			},
		},
	},
}

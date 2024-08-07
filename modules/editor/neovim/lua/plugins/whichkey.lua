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
				{ "<leader>", mode = { "n", "v" } },
				{ "<C-w>", mode = { "n", "v" } },
				{ "<localleader>", mode = { "n", "v" } },
			},
			icons = {},
			spec = {
				{ "W", hidden = true },
				{ "Q", hidden = true },
				{ "<leader>m", icon = "󱡅" },
				{ "<leader>0", icon = "" },
				{ "<leader>o", icon = "" },
				{ "<leader>f", icon = "" },
				{ "<leader>l", "<cmd>Lazy<cr>", icon = "󰒲" },
				{ "<leader>p", [["_dP]], mode = "x" },
				{ "<leader>t", group = "Treesitter", icon = "󰹩" },
				{ "<leader>h", group = "Helper", icon = "" },
				{ "<leader>n", group = "Multicursor", icon = "" },
				{ "<leader>r", group = "Spectre", icon = "󱙝" },
				{ "<leader>O", group = "Org", icon = "" },
				{ "<leader>x", group = "Trouble", icon = "" },
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

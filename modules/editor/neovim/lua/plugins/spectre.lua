return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>rt", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre" },
		{ "<leader>rw", "<cmd>lua require('spectre').toggle()<cr>", desc = "Search current word", mode = { "n" } },
		{
			"<leader>rw",
			"<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
			desc = "Search current word",
			mode = { "v" },
		},
		{ "<leader>rp", "<esc><cmd>lua require('spectre').open_visual()<CR>", desc = "Search current word" },
	},
	config = function()
		require("spectre").setup()
	end,
}

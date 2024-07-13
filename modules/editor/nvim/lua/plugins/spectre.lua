return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>S", "", desc = "+Spectre", mode = { "n", "v" } },
		{ "<leader>ST", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre" },
		{ "<leader>SW", "<cmd>lua require('spectre').toggle()<cr>", desc = "Search current word", mode = { "n" } },
		{
			"<leader>SW",
			"<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
			desc = "Search current word",
			mode = { "v" },
		},
		{ "<leader>SP", "<esc><cmd>lua require('spectre').open_visual()<CR>", desc = "Search current word" },
	},
	config = function()
		require("spectre").setup()
	end,
}

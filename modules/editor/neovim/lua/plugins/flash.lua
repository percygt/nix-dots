return {
	"folke/flash.nvim",
	event = "VeryLazy",
  -- stylua: ignore
	keys = {
		{ "<enter><enter>", "<cmd>lua require('flash').jump()<cr>", desc = "Jump to", silent = true },
		{ "<s-enter>", "<cmd>lua require('flash').treesitter()<cr>", desc = "Treesitter jump", silent = true },
		{ "<a-enter>", "<cmd>lua require('flash').treesitter_search()<cr>", desc = "Treesitter search jump", silent = true },
		{ "<c-enter>", "<cmd>lua require('flash').remote()<cr>", desc = "Remote jump", silent = true },
	},
	opts = {},
}

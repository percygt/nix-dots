return {
	"aznhe21/actions-preview.nvim",
	lazy = true,
	keys = {
		{
			"gp",
			"<cmd>lua require('actions-preview').code_actions()<cr>",
			desc = "Code actions preview",
			mode = { "n", "v" },
		},
	},
	opts = {
		telescope = {
			sorting_strategy = "ascending",
			layout_strategy = "vertical",
			layout_config = {
				width = 0.8,
				height = 0.9,
				prompt_position = "top",
				preview_cutoff = 20,
				preview_height = function(_, _, max_lines)
					return max_lines - 15
				end,
			},
		},
	},
}

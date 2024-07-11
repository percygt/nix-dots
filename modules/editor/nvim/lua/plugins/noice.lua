local map = require("config.utils").map
return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		enabled = true,
		opts = {
			background_colour = "#000000",
			enabled = false,
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		enabled = true,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		init = function()
			map({
				["<leader><leader>"] = { "<cmd>NoiceDismiss<cr>", "Noice Dismiss", silent = true },
			})
		end,
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			cmdline = {
				view = "cmdline",
				format = {
					search_down = {
						view = "cmdline",
					},
					search_up = {
						view = "cmdline",
					},
				},
			},
			presets = {
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
							{ find = "%d fewer lines" },
							{ find = "%d more lines" },
						},
					},
					opts = { skip = true },
				},
			},
		},
	},
}

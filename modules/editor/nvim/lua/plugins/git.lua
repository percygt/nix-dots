return {
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		event = "BufRead",
    -- stylua: ignore
    keys = {
			{ "<leader>g", "", desc = "+Git", mode = { "n", "v" } },
			{ "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev hunk" },
			{ "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next hunk" },
			{ "<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame" },
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
			{ "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
			{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Unstage hunk" },
			{ "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Git status" },
			{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branches" },
			{ "<leader>gg", "<cmd>Telescope git_commits<cr>", desc = "Checkout commits" },
			{ "<leader>gG", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout commits(for current buffer)" },
			{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git diff" },
    },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			status_formatter = nil,
			update_debounce = 200,
			max_file_length = 40000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>H",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "Preview git hunk" }
				)
				vim.keymap.set("n", "]]", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Next git hunk" })
				vim.keymap.set("n", "[[", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Previous git hunk" })
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	},
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"mbbill/undotree",
}

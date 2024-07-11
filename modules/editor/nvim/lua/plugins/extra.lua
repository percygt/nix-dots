return {
	{
		"folke/twilight.nvim",
		lazy = true,
		keys = {
			{ "<a-T>", "<cmd>Twilight<cr>", desc = "Twilight", silent = true },
		},
	},
	{ "brenoprata10/nvim-highlight-colors", event = "BufReadPost", opts = { render = "virtual" } },
	{ "stevearc/dressing.nvim", opts = {} },
	{ "max397574/better-escape.nvim", opts = {} },
	{
		"m4xshen/smartcolumn.nvim",
		event = "BufReadPost",
		opts = {
			colorcolumn = "100",
			{ python = "120" },
		},
	},
	-- TODO:
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			enable_autocmd = false,
		},
		config = function()
			local get_option = vim.filetype.get_option
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or get_option(filetype, option)
			end
		end,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		opts = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"karb94/neoscroll.nvim",
		opts = {
			stop_eof = true,
			easing_function = "sine",
			hide_cursor = true,
			cursor_scrolls_alone = true,
			mappings = { -- Keys to be mapped to their corresponding default scrolling animation
				"<C-u>",
				"<C-d>",
				"<C-f>",
				"<C-y>",
				"zt",
				"zz",
				"zb",
			},
		},
	},
	{
		"danymat/neogen",
		opts = {
			snippet_engine = "luasnip",
		},
	},
	-- Lua
	{
		"szw/vim-maximizer",
		keys = {
			{ "<c-w>z", "<cmd>MaximizerToggle<cr>", desc = "Window maximizer toggle", mode = { "n", "v" } },
		},
	},
}

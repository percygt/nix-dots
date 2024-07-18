return {
	{
		"folke/twilight.nvim",
		lazy = true,
		keys = {
			{ "<a-T>", "<cmd>Twilight<cr>", desc = "Twilight", silent = true },
		},
	},
	{
		"levouh/tint.nvim",
		config = function()
			-- Override some defaults
			require("tint").setup({
				tint = -50, -- Darken colors, use a positive value to brighten
				saturation = 0.6, -- Saturation to preserve
				transforms = require("tint").transforms.SATURATE_TINT, -- Showing default behavior, but value here can be predefined set of transforms
				tint_background_colors = true, -- Tint background portions of highlight groups
				highlight_ignore_patterns = { "WinSeparator", "Status.*" }, -- Highlight group patterns to ignore, see `string.find`
				window_ignore_function = function(winid)
					local bufid = vim.api.nvim_win_get_buf(winid)
					local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
					local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

					-- Do not tint `terminal` or floating windows, tint everything else
					return buftype == "terminal" or floating
				end,
			})
		end,
	},
	{
		"tzachar/local-highlight.nvim",
		lazy = true,
		config = function()
			require("local-highlight").setup({
				file_types = { "python", "cpp" }, -- If this is given only attach to this
				-- OR attach to every filetype except:
				disable_file_types = { "tex" },
				hlgroup = "Search",
				cw_hlgroup = nil,
				-- Whether to display highlights in INSERT mode or not
				insert_mode = false,
				min_match_len = 1,
				max_match_len = math.huge,
				highlight_single_match = true,
			})
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{ "brenoprata10/nvim-highlight-colors", event = "BufReadPost", opts = { render = "virtual" } },
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				default_prompt = "> ",
				relative = "editor",
				prefer_width = 50,
				prompt_align = "center",
				win_options = { winblend = 0 },
			},
			select = {
				get_config = function(opts)
					opts = opts or {}
					local config = {
						telescope = {
							layout_config = {
								width = 0.8,
							},
						},
					}
					if opts.kind == "legendary.nvim" then
						config.telescope.sorter = require("telescope.sorters").fuzzy_with_index_bias({})
					end
					return config
				end,
			},
		},
	},
	{
		"max397574/better-escape.nvim",
		opts = {
			mappings = {
				v = {
					j = {
						k = false,
					},
				},
			},
		},
	},
	{
		"m4xshen/smartcolumn.nvim",
		event = "BufReadPost",
		opts = {
			colorcolumn = "100",
			{ python = "120" },
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},
		event = { "BufNewFile", "BufReadPost" },
		config = function()
			require("todo-comments").setup({
				keywords = {
					TODO = { icon = " ", color = "#de9e00" },
				},
			})
		end,
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

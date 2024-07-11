return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"kkharji/sqlite.lua",
			"folke/trouble.nvim",
			"mfussenegger/nvim-dap",
			"debugloop/telescope-undo.nvim",
		},
		-- stylua: ignjre
		keys = {
			{ "<leader>0", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>o", "<c-6>", desc = "Switch buffer" },
			{ "<leader>s", "", desc = "+Search", mode = { "n", "v" } },
			{ "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Opened files" },
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Files" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
			{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Current word" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sn", "<cmd>Telescope notify<cr>", desc = "Notifications" },
			{ "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo" },
			{ "<leader>sl", "<cmd>TodoTelescope<cr>", desc = "Todo" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local trouble = require("trouble.sources.telescope")
			local icons = require("config.icons")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "TelescopeResults",
				callback = function(ctx)
					vim.api.nvim_buf_call(ctx.buf, function()
						vim.fn.matchadd("TelescopeParent", "\t\t.*$")
						vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
					end)
				end,
			})

			telescope.setup({
				file_ignore_patterns = { "%.git/." },
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-u>"] = false,
							["<C-d>"] = false,
							["<C-t>"] = trouble.open,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
						n = { ["<C-t>"] = trouble.open },
					},
					-- path_display = formattedName,
					path_display = {
						"filename_first",
					},
					previewer = false,
					prompt_prefix = " " .. icons.ui.Telescope .. " ",
					selection_caret = icons.ui.BoldArrowRight .. " ",
					file_ignore_patterns = { "node_modules", "package-lock.json" },
					initial_mode = "insert",
					select_strategy = "reset",
					sorting_strategy = "ascending",
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
					layout_config = {
						prompt_position = "top",
						preview_cutoff = 120,
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!.git/",
					},
				},
				pickers = {
					find_files = {
						previewer = false,
						theme = "dropdown",
						layout_config = {
							height = 0.4,
							prompt_position = "top",
							preview_cutoff = 120,
						},
						mappings = {
							n = {
								["l"] = actions.select_default,
							},
							i = {
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
							},
						},
					},
					git_files = {
						previewer = false,
						layout_config = {
							height = 0.4,
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					buffers = {
						mappings = {
							i = {
								["D"] = actions.delete_buffer + actions.move_to_top,
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
							},
							n = {
								["D"] = actions.delete_buffer + actions.move_to_top,
								["l"] = actions.select_default,
							},
						},
						ignore_current_buffer = true,
						sort_lastused = true,
						previewer = false,
						initial_mode = "normal",
						theme = "dropdown",
						layout_config = {
							height = 0.4,
							width = 0.6,
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					current_buffer_fuzzy_find = {
						previewer = true,
						layout_config = {
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					live_grep = {
						only_sort_text = true,
						previewer = true,
					},
					grep_string = {
						only_sort_text = true,
						previewer = true,
					},
					lsp_references = {
						show_line = false,
						previewer = true,
					},
					treesitter = {
						show_line = false,
						previewer = true,
					},
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							previewer = false,
							initial_mode = "normal",
							sorting_strategy = "ascending",
							layout_strategy = "horizontal",
							layout_config = {
								horizontal = {
									width = 0.5,
									height = 0.4,
									preview_width = 0.6,
								},
							},
						}),
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			-- telescope.load_extension("refactoring")
			telescope.load_extension("dap")
			-- telescope.load_extension("frecency")
			telescope.load_extension("notify")
			-- telescope.load_extension("git_worktree")
			telescope.load_extension("undo")
		end,
	},
}

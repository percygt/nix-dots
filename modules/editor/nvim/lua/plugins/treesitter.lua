return {
	-- Universal language parser
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
		},
		keys = { "<leader>T", "<cmd>Inspect<cr>", desc = "Show highlighting groups and captures" },
		config = function()
			if vim.gcc_bin_path ~= nil then
				require("nvim-treesitter.install").compilers = { vim.g.gcc_bin_path }
			end

			require("nvim-treesitter.configs").setup({
				sync_install = false,
				ignore_install = { "javascript" },
				auto_install = true,
				ensure_installed = {
					"html",
					"bash",
					"fish",
					"json",
					"lua",
					"markdown",
					"nix",
					"python",
					"rust",
					"toml",
					"vim",
					"regex",
					"jsonc",
					"markdown_inline",
				},
				indent = {
					enable = true,
					disable = { "python", "yaml" }, -- Yaml and Python indents are unusable
				},
				highlight = {
					enable = true,
					disable = { "yaml" },
					additional_vim_regex_highlighting = false,
				},
				-- autopairs = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<leader>vv",
						node_incremental = "+",
						scope_incremental = false,
						node_decremental = "_",
					},
				},
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["il"] = "@loop.inner",
							["al"] = "@loop.outer",
							["ak"] = "@block.outer",
							["ik"] = "@block.inner",
							["is"] = "@statement.inner",
							["as"] = "@statement.outer",
							["am"] = "@call.outer",
							["im"] = "@call.inner",
							["at"] = "@comment.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["(a"] = "@parameter.inner",
						},
						swap_previous = {
							["(A"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	-- {
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	event = "BufRead",
	-- },
	-- -- Show sticky context for off-screen scope beginnings
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufRead",
		opts = {
			enable = true,
			max_lines = 5,
			trim_scope = "outer",
			zindex = 40,
			mode = "cursor",
			separator = nil,
		},
	},
	-- -- Playground treesitter utility
	-- {
	-- 	"nvim-treesitter/playground",
	-- 	cmd = "TSPlaygroundToggle",
	-- },
	-- -- RON syntax plugin
	-- {
	-- 	"ron-rs/ron.vim",
	-- 	ft = "ron",
	-- },
	-- -- Syntax-aware text objects and motions
	-- {
	-- 	"ziontee113/syntax-tree-surfer",
	-- 	cmd = {
	-- 		"STSSwapPrevVisual",
	-- 		"STSSwapNextVisual",
	-- 		"STSSelectPrevSiblingNode",
	-- 		"STSSelectNextSiblingNode",
	-- 		"STSSelectParentNode",
	-- 		"STSSelectChildNode",
	-- 		"STSSwapOrHold",
	-- 		"STSSelectCurrentNode",
	-- 	},
	-- 	init = function()
	-- 		local function dot_repeatable(op)
	-- 			return function()
	-- 				require("syntax-tree-surfer")
	-- 				vim.opt.opfunc = op
	-- 				return "g@l"
	-- 			end
	-- 		end
	--
	-- 		map({
	-- 			["<M-Up>"] = { dot_repeatable("v:lua.STSSwapUpNormal_Dot"), "Swap node upwards", expr = true },
	-- 			["<M-Down>"] = { dot_repeatable("v:lua.STSSwapDownNormal_Dot"), "Swap node downwards", expr = true },
	-- 			["<M-Left>"] = {
	-- 				dot_repeatable("v:lua.STSSwapCurrentNodePrevNormal_Dot"),
	-- 				"Swap with previous node",
	-- 				expr = true,
	-- 			},
	-- 			["<M-Right>"] = {
	-- 				dot_repeatable("v:lua.STSSwapCurrentNodeNextNormal_Dot"),
	-- 				"Swap with next node",
	-- 				expr = true,
	-- 			},
	-- 			["gO"] = {
	-- 				function()
	-- 					require("syntax-tree-surfer").go_to_top_node_and_execute_commands(false, {
	-- 						"normal! O",
	-- 						"normal! O",
	-- 						"startinsert",
	-- 					})
	-- 				end,
	-- 				"Insert above top-level node",
	-- 			},
	-- 			["go"] = {
	-- 				function()
	-- 					require("syntax-tree-surfer").go_to_top_node_and_execute_commands(true, {
	-- 						"normal! o",
	-- 						"normal! o",
	-- 						"startinsert",
	-- 					})
	-- 				end,
	-- 				"Insert below top-level node",
	-- 			},
	-- 			["<leader>h"] = { "<CMD>STSSwapOrHold<CR>", "Hold or swap with held node" },
	-- 			["<Cr>"] = { "<CMD>STSSelectCurrentNode<CR>", "Select current node" },
	-- 		})
	--
	-- 		map({
	-- 			["<M-Up>"] = { "<CMD>STSSwapPrevVisual<CR>", "Swap with previous node" },
	-- 			["<M-Down>"] = { "<CMD>STSSwapNextVisual<CR>", "Swap with next node" },
	-- 			["<M-Left>"] = { "<CMD>STSSwapPrevVisual<CR>", "Swap with previous node" },
	-- 			["<M-Right>"] = { "<CMD>STSSwapNextVisual<CR>", "Swap with next node" },
	-- 			["<C-Up>"] = { "<CMD>STSSelectPrevSiblingNode<CR>", "Select previous sibling" },
	-- 			["<C-Down>"] = { "<CMD>STSSelectNextSiblingNode<CR>", "Select next sibling" },
	-- 			["<C-Left>"] = { "<CMD>STSSelectPrevSiblingNode<CR>", "Select previous sibling" },
	-- 			["<C-Right>"] = { "<CMD>STSSelectNextSiblingNode<CR>", "Select next sibling" },
	-- 			["<Cr>"] = { "<CMD>STSSelectParentNode<CR>", "Select parent node" },
	-- 			["<S-Cr>"] = { "<CMD>STSSelectChildNode<CR>", "Select child node" },
	-- 			["<leader>h"] = { "<CMD>STSSwapOrHold<CR>", "Hold or swap with held node" },
	-- 		}, { mode = "x" })
	-- 	end,
	-- 	config = true,
	-- },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		opts = {
			signs = false,
		},
	},
}

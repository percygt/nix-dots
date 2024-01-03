require("nvim-treesitter.configs").setup({
	auto_install = false, -- Parsers are managed by Nix
	indent = {
		enable = true,
		disable = { "python", "yaml" }, -- Yaml and Python indents are unusable
	},
	highlight = {
		enable = true,
		disable = { "yaml" },
		additional_vim_regex_highlighting = false,
	},
	autopairs = { enable = true },

	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["ap"] = "@parameter.outer",
				["ip"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				["il"] = "@loop.inner",
				["al"] = "@loop.outer",
				["at"] = "@comment.outer",
			},
		},
		-- swap = {
		-- 	enable = true,
		-- 	swap_next = {
		-- 		["<leader>a"] = "@parameter.inner",
		-- 	},
		-- 	swap_previous = {
		-- 		["<leader>A"] = "@parameter.inner",
		-- 	},
		-- },
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

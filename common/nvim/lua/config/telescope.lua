local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local wk = require("which-key")

telescope.load_extension("harpoon")
telescope.load_extension("git_worktree")
telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
telescope.load_extension("file_browser")

wk.register({
	-- ["?"] = { builtin.oldfiles, { "[?] Find recently opened files" } },
	-- ["/"] = {
	-- 	function()
	-- 		-- You can pass additional configuration to telescope to change theme, layout, etc.
	-- 		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
	-- 			winblend = 10,
	-- 			previewer = false,
	-- 		}))
	-- 	end,
	-- 	{ "[/] Fuzzily search in current buffer]" },
	-- },
	s = {
		name = "Telescope",
		f = { builtin.find_files, "Find file" },
		g = { builtin.live_grep, "Live grep" },
		b = { builtin.buffers, "Buffers" },
		h = { builtin.help_tags, "Help tags" },
		t = { builtin.treesitter, "Treesitter" },
		r = { builtin.lsp_references, "References" },
		c = { builtin.commands, "Commands" },
		f = { builtin.find_files, "[S]earch [F]iles" },
		h = { builtin.help_tags, "[S]earch [H]elp" },
		w = { builtin.grep_string, "[S]earch current [W]ord" },
		g = { builtin.live_grep, "[S]earch by [G]rep" },
		d = { builtin.diagnostics, "[S]earch [D]iagnostics" },
		b = { builtin.buffers, "[ ] Find existing buffers" },
		S = { builtin.git_status, "" },
		m = { ":Telescope harpoon marks<CR>", "Harpoon [M]arks" },
		r = { "<CMD>lua telescope.extensions.git_worktree.git_worktrees()<CR>", silent },
		R = { "<CMD>lua telescope.extensions.git_worktree.create_git_worktree()<CR>", silent },
		n = { "<CMD>lua telescope.extensions.notify.notify()<CR>", silent },
	},
}, { prefix = "<leader>" })

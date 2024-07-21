return {
	{ "echasnovski/mini.ai", version = false, opts = { n_lines = 500 } },
	{ "echasnovski/mini.surround", version = false, opts = {} },
	{
		"echasnovski/mini.move",
		version = false,
		opts = {
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				right = "<M-l>",
				left = "<M-h>",
				down = "<M-j>",
				up = "<M-k>",

				-- Move current line in Normal mode
				line_right = "<M-l>",
				line_left = "<M-h>",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},

			-- Options which control moving behavior
			options = {
				-- Automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		},
	},
	{ "echasnovski/mini.pairs", version = false },
}

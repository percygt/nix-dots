require("lazy").setup({ import = "plugins" }, {
	install = {
		missing = true,
		colorscheme = { "onedark", "habamax" },
	},
	rocks = { enabled = false },
	-- dev = {
	-- 	path = "~/.local/share/nvim/nix",
	-- 	fallback = false,
	-- },
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
	ui = {
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

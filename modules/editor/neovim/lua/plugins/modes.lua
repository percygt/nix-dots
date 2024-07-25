return {
	"mvllow/modes.nvim",
	config = function()
		local c = require("config.colorscheme")
		require("modes").setup({
			colors = {
				bg = "", -- Optional bg param, defaults to Normal hl group
				copy = c.base0B6,
				delete = c.base07,
				insert = c.base0E,
				visual = c.base0D,
			},
			line_opacity = 0.35,
		})
	end,
}

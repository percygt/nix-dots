return {
	"mvllow/modes.nvim",
	config = function()
		require("modes").setup({
			colors = {
				bg = "", -- Optional bg param, defaults to Normal hl group
				copy = "#f5c359",
				delete = "#c75c6a",
				-- insert = "",
				visual = "#f5c359",
			},
			-- line_opacity = 1,
		})
	end,
}

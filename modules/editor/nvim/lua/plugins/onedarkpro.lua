-- Lazy
return {
	"olimorris/onedarkpro.nvim",
	priority = 1000, -- Ensure it loads first
	enabled = false,
	init = function()
		vim.o.guicursor = "n-o:block-nCursor,i:ver20-iCursor,v-ve:block-vCursor,c-ci-cr:ver25-cCursor,r:hor15-rCursor"
	end,
	config = function()
		require("onedarkpro").setup({
			colors = require("config.colorscheme"),
			options = {
				cursorline = false,
				transparency = true,
				highlight_inactive_windows = true,
			},
			highlights = {
				WinSeparator = { fg = "${base0D}" },
				NormalFloat = { bg = "${none}" },
				WhichKeyBorder = { bg = "${none}", fg = "${base03}" },
				CursorLine = { bg = "${base01}" },
				CursorLineNr = { bg = "${base01}", fg = "${base06}", bold = true, italic = true },
				ColorColumn = { bg = "${base10}" },
				-- LineNr = { fg = "${base04}" },
				-- LineNrNC = { fg = "${base04}" },
				MatchParen = { fg = "${base0A}", bg = "${none}", underline = true },
				-- ["@function"] = { fg = "${none}", italic = true },
				-- ["@variable"] = { fg = "${fg}", bold = true, italic = false },
				-- ["@variable.other"] = { fg = "${fg}", bold = true },
				-- ["@variable.parameter"] = { fg = "${fg}", bold = true },
				-- ["@variable.member"] = { fg = "${fg}", bold = true },
				-- -- ["@lsp.type.property.lua"] = { fg = "${fg}", italic = false },
				-- ["@string"] = { fg = "#abb2bf" },
				-- ["@constructor.lua"] = { fg = "${grey}", bold = true },
			},
			styles = {
				types = "NONE",
				methods = "NONE",
				numbers = "NONE",
				strings = "NONE",
				comments = "italic",
				keywords = "bold,italic",
				constants = "bold",
				functions = "NONE",
				operators = "NONE",
				variables = "bold",
				parameters = "NONE",
				conditionals = "italic",
				virtual_text = "NONE",
			},
		})
		-- vim.cmd("colorscheme onedark_dark")
	end,
}

-- Lazy
return {
	"olimorris/onedarkpro.nvim",
	priority = 1000, -- Ensure it loads first
	config = function()
		require("onedarkpro").setup({
			colors = require("config.colors"),
			options = {
				cursorline = false,
				transparency = true,
				highlight_inactive_windows = true,
			},
			highlights = {
				NormalFloat = { bg = "${none}" },
				WhichKeyBorder = { bg = "${none}", fg = "${cyan}" },
				CursorLine = { bg = "${midnight}" },
				CursorLineNr = { fg = "${lavender}", bold = true, italic = true },
				ColorColumn = { bg = "${abyss}" },
				LineNr = { fg = "${grey}" },
				LineNrNC = { fg = "${grey}" },
				Visual = { bg = "${navynight}" },
				MatchParen = { fg = "${yellow}", bg = "${none}", underline = true },
				-- Cursor = { fg = "${black}", bg = "${none}" },
				["@function"] = { fg = "${none}", italic = true },
				-- ["@lsp.type.variable"] = { fg = "${fg}", bold = true },
				["@variable"] = { fg = "${fg}", bold = true, italic = false },
				["@variable.other"] = { fg = "${fg}", bold = true },
				["@variable.parameter"] = { fg = "${fg}", bold = true },
				["@variable.member"] = { fg = "${fg}", bold = true },
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
		vim.cmd("colorscheme onedark_dark")
		local colors = require("onedarkpro.helpers").get_colors()
		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "IndentYellow", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "IndentBlack", { fg = colors.black })
		end)

		require("ibl").setup({
			scope = {
				enabled = true,
				char = "▏",
				highlight = "IndentYellow",
			},
			indent = {
				char = "▏",
				smart_indent_cap = true,
				highlight = "IndentBlack",
			},
		})

		local mode = require("utils")
		vim.o.guicursor = "n-o:block-nCursor,i:ver20-iCursor,v-ve:block-vCursor,c-ci-cr:ver25-cCursor,r:hor15-rCursor"

		-- cursor color
		vim.api.nvim_set_hl(0, "nCursor", { bg = colors.lavender, fg = colors.bg0 })
		vim.api.nvim_set_hl(0, "iCursor", { bg = colors.peach, fg = colors.bg0 })
		vim.api.nvim_set_hl(0, "vCursor", { bg = colors.rosewater, fg = colors.bg0 })
		vim.api.nvim_set_hl(0, "cCursor", { bg = colors.sky, fg = colors.bg0 })
		vim.api.nvim_set_hl(0, "rCursor", { bg = colors.sapphire, fg = colors.bg0 })

		-- color for split
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.blue })

		-- cursor line color
		vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.midnight })

		-- line number color
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.lavender })

		-- cursor color
		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "*",
			callback = function()
				if mode.isNormal() then
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.lavender })
				elseif mode.isInsert() then
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.peach })
				elseif mode.isVisual() then
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.rosewater })
				elseif mode.isReplace() then
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.sapphire })
				end
				-- command mode doesn't have line number
			end,
		})
	end,
}

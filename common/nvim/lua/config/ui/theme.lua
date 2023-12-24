local helper = require("config.helper")

require("onedark").setup({
	style = "deep",
	transparent = true,
	ending_tildes = true,
	toggle_style_key = "<leader>ts", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
	code_style = {
		comments = "italic",
		keywords = "none",
		functions = "italic",
		strings = "none",
		variables = "bold",
	},
	colors = {
		bg0 = "#000000",
		bg1 = "#0a0714",
		bg2 = "#120d22",
		bg3 = "#0e1a60",
		bg_d = "#030205",
		fg = "#96c7f1",
		yellow = "#a1d408",
		cyan = "#61deda",
		matchParen = "#003390",

		--Catpuccin stuff
		lavender = "#b4befe",
		rosewater = "#f5e0dc",
		peach = "#fab387",
		sapphire = "#74c7ec",
		sky = "#89dceb",
		mauve = "#cba6f7",
	},
	highlights = {
		["@lsp.type.variable"] = { fg = "$fg", fmt = "bold" },
		["@variable"] = { fg = "$fg", fmt = "bold" },
		["@variable.other"] = { fg = "$fg", fmt = "bold" },
		["@variable.parameter"] = { fg = "$fg", fmt = "bold" },
		["@string.quoted.astro"] = { fg = "$fg" },
		["@meta.jsx.children.tsx"] = { fg = "$fg" },
		["@string.quoted.double.tsx"] = { fg = "$fg" },
		["@string.template"] = { fg = "$fg" },

		["@entity.other.attribute-name"] = { fg = "$yellow", fmt = "italic" },
		["@entity.other.attribute-name.tsx"] = { fg = "$yellow", fmt = "italic" },
		["@entity.other.attribute-name.class.css"] = { fg = "$yellow", fmt = "italic" },

		["@entity.name.type.class"] = { fg = "$yellow", fmt = "italic" },
		["@meta.function"] = { fg = "$yellow", fmt = "italic" },
		["@meta.function-call"] = { fg = "$yellow", fmt = "italic" },

		["@support.class.component.tsx"] = { fg = "$cyan", fmt = "italic" },
		["@support.class.component.astro"] = { fg = "$cyan", fmt = "italic" },
		["@punctuation.definition.tag"] = { fg = "$cyan", fmt = "italic" },

		["@punctuation.definition.template-expression.begin"] = { fmt = "italic" },
		["@punctuation.definition.template-expression.end"] = { fmt = "italic" },
		["@punctuation.section.embedded"] = { fmt = "italic" },
		["@meta.decorator "] = { fmt = "italic" },
		["@punctuation.decorator"] = { fmt = "italic" },

		["@punctuation.definition.comment"] = { fg = "$dark_red", fmt = "italic" },
		["@comment"] = { fg = "$dark_red", fmt = "italic" },

		["@entity.name.tag"] = { fg = "$grey", fmt = "italic" },
		["@support.type.property-name"] = { fg = "$grey", fmt = "italic" },

		["@keyword"] = { fmt = "italic" },
		["@constant"] = { fmt = "italic" },
		["@storage.modifier"] = { fmt = "italic" },
		["@storage.type"] = { fmt = "italic" },
		["@storage.type.class.js"] = { fmt = "italic" },

		["@entity.name.function"] = { fg = "$blue", fmt = "bold" },
		["@entity.name.type.alias"] = { fg = "$red", fmt = "bold" },

		["@keyword.control"] = { fmt = "italic" },

		MatchParen = { fg = "$none", bg = "$matchParen" },
	},
})
require("onedark").load()

local colors = require("onedark.colors")

-- cursor color
vim.api.nvim_set_hl(0, "nCursor", { bg = colors.blue, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "iCursor", { bg = colors.green, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "vCursor", { bg = colors.purple, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "cCursor", { bg = colors.yellow, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "rCursor", { bg = colors.red, fg = colors.bg0 })

vim.o.guicursor = "n-o:block-nCursor,i:ver20-iCursor,v-ve:block-vCursor,c-ci-cr:ver25-cCursor,r:hor15-rCursor"

-- color for split
vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.blue })
-- line number color
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue })
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if helper.isNormal() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue })
		elseif helper.isInsert() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.green })
		elseif helper.isVisual() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.purple })
		elseif helper.isReplace() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.red })
		end

		-- command mode doesn't have line number
	end,
}) -- format when savew

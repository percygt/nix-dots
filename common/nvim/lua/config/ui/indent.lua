local colors = require("onedark.colors")
local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "IndentRed", { fg = colors.red })
	vim.api.nvim_set_hl(0, "IndentOrange", { fg = colors.orange })
	vim.api.nvim_set_hl(0, "IndentYellow", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "IndentGreen", { fg = colors.green })
	vim.api.nvim_set_hl(0, "IndentCyan", { fg = colors.cyan })
	vim.api.nvim_set_hl(0, "IndentPurple", { fg = colors.purple })
	vim.api.nvim_set_hl(0, "IndentBlack", { fg = colors.black })
end)

local indent_highlight = {
	"IndentRed",
	"IndentOrange",
	"IndentYellow",
	"IndentGreen",
	"IndentCyan",
	"IndentPurple",
}

require("ibl").setup({
	scope = {
		enabled = true,
		char = "▏",
		highlight = indent_highlight,
	},
	indent = {
		char = "▏",
		smart_indent_cap = true,
		highlight = "IndentBlack",
	},
})

local utils = require("config.utils")
vim.cmd([[colorscheme onedark]])

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
	lualine = {
		transparent = true, -- lualine center bar transparency
	},
	colors = {
		bg0 = "#000000",
		bg1 = "#000f34",
		bg2 = "#001a3e",
		bg3 = "#072349",

		matchParen = "#003390",
	},
	highlights = {
		["@lsp.type.variable"] = { fg = "$red" },
		["@variable"] = { fg = "$red" },
		["@lsp.mod.readonly"] = { fg = "$yellow", fmt = "bold" },
		["@operator"] = { fg = "$cyan" },
		MatchParen = { fg = "$none", bg = "$matchParen" },
	},
})
require("onedark").load()

local colors = require("onedark.colors")

-- cursor color
vim.api.nvim_set_hl(0, "nCursor", { bg = colors.blue, fg = colors.black })
vim.api.nvim_set_hl(0, "iCursor", { bg = colors.green, fg = colors.black })
vim.api.nvim_set_hl(0, "vCursor", { bg = colors.purple, fg = colors.black })
vim.api.nvim_set_hl(0, "cCursor", { bg = colors.yellow, fg = colors.black })
vim.api.nvim_set_hl(0, "rCursor", { bg = colors.red, fg = colors.black })

vim.o.guicursor = "n-o:block-nCursor,i:ver20-iCursor,v-ve:block-vCursor,c-ci-cr:ver25-cCursor,r:hor15-rCursor"

-- line number color
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue })
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if utils.isNormal() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue })
		elseif utils.isInsert() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.green })
		elseif utils.isVisual() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.purple })
		elseif utils.isReplace() then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.red })
		end

		-- command mode doesn't have line number
	end,
}) -- format when save

-- color for split
vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.black })
-- color for bufferline
vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.black })

local indent_highlight = {
	"IndentRainbowRed",
	"IndentRainbowYellow",
	"IndentRainbowBlue",
	"IndentRainbowOrange",
	"IndentRainbowGreen",
	"IndentRainbowViolet",
	"IndentRainbowCyan",
}

local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "IndentRainbowRed", { fg = colors.red })
	vim.api.nvim_set_hl(0, "IndentRainbowYellow", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "IndentRainbowBlue", { fg = colors.blue })
	vim.api.nvim_set_hl(0, "IndentRainbowOrange", { fg = colors.orange })
	vim.api.nvim_set_hl(0, "IndentRainbowGreen", { fg = colors.green })
	vim.api.nvim_set_hl(0, "IndentRainbowViolet", { fg = colors.purple })
	vim.api.nvim_set_hl(0, "IndentRainbowCyan", { fg = colors.cyan })
	vim.api.nvim_set_hl(0, "IndentBlack", { fg = colors.black })
end)

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

require("lualine").setup({
	options = {
		component_separators = { left = "\\", right = "/" },
		section_separators = { left = "", right = "" },
		theme = onedark,
		disabled_filetypes = { tabline = { "NvimTree" } },
		-- globalstatus = true,
	},
	extensions = { "nvim-tree" },

	sections = {
		lualine_a = {
			{
				"mode",
				icon_enable = true,
				fmt = function()
					return utils.isNormal() and ""
						or utils.isInsert() and ""
						or utils.isVisual() and "󰒉"
						or utils.isCommand() and ""
						or utils.isReplace() and ""
						or vim.api.nvim_get_mode().mode == "t" and ""
						or ""
				end,
			},
			"mode",
		},
		lualine_b = { "buffers" },
		lualine_c = {},
		lualine_x = { "diagnostics", "filesize" },
		lualine_y = {
			{
				"progress",
				color = function()
					return {
						fg = vim.fn.synIDattr(
							vim.fn.synIDtrans(
								vim.fn.hlID(
									"progressHl" .. (math.floor(((vim.fn.line(".") / vim.fn.line("$")) / 0.17))) + 1
								)
							),
							"fg"
						),
					}
				end,
			},
		},
		lualine_z = {
			{
				"selectioncount",
				fmt = function(count)
					if count == "" then
						return ""
					end
					return "[" .. count .. "]"
				end,
			},
			{
				"location",
			},
		},
	},
	inactive_sections = {
		lualine_a = {
			{ "filetype", colored = true, icon_only = true, icon = { align = "right" } },
			"filename",
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{
				function()
					return vim.api.nvim_get_current_win() .. ":" .. vim.api.nvim_get_current_buf()
				end,
			},
		},
		lualine_z = { "location" },
	},
	tabline = {
		lualine_a = {
			{
				require("noice").api.statusline.mode.get,
				cond = require("noice").api.statusline.mode.has,
				color = { fg = "#ff9e64" },
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			"branch",
			"diff",
			{
				function()
					return vim.api.nvim_get_current_win() .. ":" .. vim.api.nvim_get_current_buf()
				end,
			},
		},
		lualine_z = { "tabs" },
	},
})

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
-- Sort automatically by...
map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

return {
	{
		"navarasu/onedark.nvim",
		priority = 150,
		dependencies = { "lukas-reineke/indent-blankline.nvim" },
		enabled = false,
		name = "onedark",
		config = function()
			local mode = require("utils")
			require("onedark").setup({
				style = "deep",
				transparent = true,
				ending_tildes = true,
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
				colors = require("config.colors"),
				highlights = {
					["@lsp.type.variable"] = { fg = "$fg", fmt = "bold" },
					["@variable"] = { fg = "$fg", fmt = "bold" },
					["@variable.other"] = { fg = "$fg", fmt = "bold" },
					["@variable.parameter"] = { fg = "$fg", fmt = "bold" },
					["@string.quoted.astro"] = { fg = "$fg" },
					["@meta.jsx.children.tsx"] = { fg = "$fg" },
					["@string.quoted.double.tsx"] = { fg = "$fg" },
					["@string.template"] = { fg = "$fg" },

					["@support.class.component.tsx"] = { fg = "$cyan", fmt = "italic" },
					["@support.class.component.astro"] = { fg = "$cyan", fmt = "italic" },
					["@punctuation.definition.tag"] = { fg = "$cyan", fmt = "italic" },

					["@punctuation.definition.template-expression.begin"] = { fmt = "italic" },
					["@punctuation.definition.template-expression.end"] = { fmt = "italic" },
					["@punctuation.section.embedded"] = { fmt = "italic" },
					["@meta.decorator "] = { fmt = "italic" },
					["@punctuation.decorator"] = { fmt = "italic" },

					-- ["@punctuation.definition.comment"] = { fg = "$dark_red", fmt = "italic" },
					-- ["@comment"] = { fg = "$dark_red", fmt = "italic" },

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

			vim.o.guicursor =
				"n-o:block-nCursor,i:ver20-iCursor,v-ve:block-vCursor,c-ci-cr:ver25-cCursor,r:hor15-rCursor"

			-- cursor color
			vim.api.nvim_set_hl(0, "nCursor", { bg = colors.lavender, fg = colors.bg0 })
			vim.api.nvim_set_hl(0, "iCursor", { bg = colors.peace, fg = colors.bg0 })
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
			vim.api.nvim_set_hl(0, "iCursor", { bg = colors.peace, fg = colors.bg0 })
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
	},
}

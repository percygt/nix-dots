return {
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local c = require("config.colorscheme")

			local customOneDark = {
				inactive = {
					a = { fg = c.base03, bg = c.base01, gui = "italic" },
					b = { bg = c.base00 },
					c = { bg = c.base00 },
				},
				normal = {
					a = { fg = c.base05, bg = c.base03, gui = "italic" },
					b = { bg = c.base10 },
					c = { bg = c.base10 },
				},
				visual = { a = { fg = c.base10, bg = c.base09, gui = "italic" } },
				insert = { a = { fg = c.base10, bg = c.base16, gui = "italic" } },
			}
			-- LSP clients attached to buffer
			local function clients_lsp()
				local buf_clients = nil
				buf_clients = vim.lsp.get_clients({ bufnr = 0 })
				local buf_client_names = {}
				for _, client in pairs(buf_clients) do
					table.insert(buf_client_names, client.name)
				end
				return table.concat(buf_client_names, "|")
			end
			-- color for lualine progress
			vim.api.nvim_set_hl(0, "progressHl1", { fg = c.base06 })
			vim.api.nvim_set_hl(0, "progressHl2", { fg = c.base09 })
			vim.api.nvim_set_hl(0, "progressHl3", { fg = c.base0A })
			vim.api.nvim_set_hl(0, "progressHl4", { fg = c.base0B })
			vim.api.nvim_set_hl(0, "progressHl5", { fg = c.base0C })
			vim.api.nvim_set_hl(0, "progressHl6", { fg = c.base0D })
			vim.api.nvim_set_hl(0, "progressHl7", { fg = c.base0E })

			local function is_active()
				local ok, hydra = pcall(require, "hydra.statusline")
				return ok and hydra.is_active()
			end

			local function get_name()
				local ok, hydra = pcall(require, "hydra.statusline")
				if ok then
					return hydra.get_name()
				end
				return ""
			end
			require("lualine").setup({
				options = {
					theme = customOneDark,
					globalstatus = true,
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "|", right = "|" },
					disabled_filetypes = {
						statusline = {
							"help",
							"Trouble",
							"spectre_panel",
						},
						winbar = {},
					},
				},
				sections = {
					lualine_a = {
						function()
							return "nvim"
						end,
					},
					lualine_b = {
						{ "harpoon2" },
					},
					lualine_c = {
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " " },
						},
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = c.base07 },
						},
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = c.base09 },
						},
						{
							"selectioncount",
							fmt = function(count)
								if count == "" then
									return ""
								end
								return "[" .. count .. "]"
							end,
						},
						-- multicursor status
						{ get_name, cond = is_active },
					},
					lualine_x = {
						{ "diff" },
					},
					lualine_y = {
						clients_lsp,
					},
					lualine_z = {
						{
							"progress",
							color = function()
								return {
									fg = vim.fn.synIDattr(
										vim.fn.synIDtrans(
											vim.fn.hlID(
												"progressHl"
													.. (math.floor(((vim.fn.line(".") / vim.fn.line("$")) / 0.17)))
														+ 1
											)
										),
										"fg"
									),
								}
							end,
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					-- lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = { "neo-tree", "lazy" },
			})
		end,
	},
	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
			},
		},
	},
}

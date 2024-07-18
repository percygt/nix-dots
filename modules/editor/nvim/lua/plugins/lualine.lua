return {
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local colors = require("onedarkpro.helpers").get_colors()

			local customOneDark = {
				inactive = {
					a = { fg = colors.grey, bg = colors.midnight, gui = "italic" },
					b = { fg = colors.grey, bg = colors.black },
					c = { fg = colors.grey, bg = colors.black },
				},
				normal = {
					a = { bg = colors.midnight, gui = "italic" },
					b = { bg = colors.bg },
					c = { bg = colors.bg },
				},
				visual = { a = { bg = colors.navynight, gui = "italic" } },
				insert = { a = { bg = colors.azure, gui = "italic" } },
				-- replace = { a = { fg = colors.black, bg = colors.sapphire, gui = "italic" } },
				-- command = { a = { fg = colors.black, bg = colors.sky, gui = "italic" } },
				-- terminal = { a = { fg = colors.black, bg = colors.mauve, gui = "italic" } },
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
			vim.api.nvim_set_hl(0, "progressHl1", { fg = colors.red })
			vim.api.nvim_set_hl(0, "progressHl2", { fg = colors.orange })
			vim.api.nvim_set_hl(0, "progressHl3", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "progressHl4", { fg = colors.green })
			vim.api.nvim_set_hl(0, "progressHl5", { fg = colors.cyan })
			vim.api.nvim_set_hl(0, "progressHl6", { fg = colors.blue })
			vim.api.nvim_set_hl(0, "progressHl7", { fg = colors.purple })

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
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " " },
						},
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = colors.lavender },
						},
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = colors.peach },
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
					lualine_c = {
						{ "harpoon2" },
					},
					lualine_x = {
						{ "diff", symbols = { added = "󰐙 ", modified = "󱨧 ", removed = "󰍷 " } },
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

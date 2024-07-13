return {
	{
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-completion",
		"kristijanhusak/vim-dadbod-ui",
		keys = {
			{ "<leader>S", "", desc = "+Database", mode = { "n", "v" } },
			{ "<leader>St", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
			{ "<leader>Sf", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
			{ "<leader>Sr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
			{ "<leader>Sq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
		},
		config = function()
			vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"sql",
				},
				command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"sql",
					"mysql",
					"plsql",
				},
				callback = function()
					vim.schedule(require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } }))
				end,
			})
		end,
	},
	{ "kkharji/sqlite.lua" },
}

return {
	setKey = vim.keymap.set,
	delKey = vim.keymap.del,
	addCommand = vim.api.nvim_create_user_command,
	isNormal = function()
		return vim.tbl_contains({ "n", "niI", "niR", "niV", "nt", "ntT" }, vim.api.nvim_get_mode().mode)
	end,
	isInsert = function()
		return vim.tbl_contains({ "i", "ic", "ix" }, vim.api.nvim_get_mode().mode)
	end,
	isVisual = function()
		return vim.tbl_contains({ "v", "vs", "V", "Vs", "\22", "\22s", "s", "S", "\19" }, vim.api.nvim_get_mode().mode)
	end,
	isCommand = function()
		return vim.tbl_contains({ "c", "cv", "ce", "rm", "r?" }, vim.api.nvim_get_mode().mode)
	end,
	isReplace = function()
		return vim.tbl_contains({ "R", "Rc", "Rx", "Rv", "Rvc", "Rvx", "r" }, vim.api.nvim_get_mode().mode)
	end,
}

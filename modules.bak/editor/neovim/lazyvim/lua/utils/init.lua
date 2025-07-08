local M = {}

local function bind(op, outer_opts)
	outer_opts = outer_opts or {}
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

M.nmap = bind("n")
M.vmap = bind("v")
M.imap = bind("i")
M.xmap = bind("x")
M.cmap = bind("c")
M.nvmap = bind({ "n", "v" })

M.isNormal = function()
	return vim.tbl_contains({ "n", "niI", "niR", "niV", "nt", "ntT" }, vim.api.nvim_get_mode().mode)
end
M.isInsert = function()
	return vim.tbl_contains({ "i", "ic", "ix" }, vim.api.nvim_get_mode().mode)
end
M.isVisual = function()
	return vim.tbl_contains({ "v", "vs", "V", "Vs", "\22", "\22s", "s", "S", "\19" }, vim.api.nvim_get_mode().mode)
end
M.isCommand = function()
	return vim.tbl_contains({ "c", "cv", "ce", "rm", "r?" }, vim.api.nvim_get_mode().mode)
end
M.isReplace = function()
	return vim.tbl_contains({ "R", "Rc", "Rx", "Rv", "Rvc", "Rvx", "r" }, vim.api.nvim_get_mode().mode)
end
return M

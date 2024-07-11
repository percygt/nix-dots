-- See `:help vim.highlight.on_yank()`
-- local lsp = require("vim.lsp")
-- local get_clients = vim.lsp.get_clients
--
-- vim.api.nvim_create_user_command("LspStop", function(kwargs)
-- 	local name = kwargs.fargs[1]
-- 	for _, client in ipairs(get_clients({ name = name })) do
-- 		client.stop()
-- 	end
-- end, {
-- 	nargs = 1,
-- 	complete = function()
-- 		return vim.tbl_map(function(c)
-- 			return c.name
-- 		end, get_clients())
-- 	end,
-- })
-- vim.api.nvim_create_user_command("LspRestart", function(kwargs)
-- 	local name = kwargs.fargs[1]
-- 	for _, client in ipairs(get_clients({ name = name })) do
-- 		local bufs = lsp.get_buffers_by_client_id(client.id)
-- 		client.stop()
-- 		vim.wait(30000, function()
-- 			return lsp.get_client_by_id(client.id) == nil
-- 		end)
-- 		local client_id = lsp.start_client(client.config)
-- 		if client_id then
-- 			for _, buf in ipairs(bufs) do
-- 				lsp.buf_attach_client(buf, client_id)
-- 			end
-- 		end
-- 	end
-- end, {
-- 	nargs = 1,
-- 	complete = function()
-- 		return vim.tbl_map(function(c)
-- 			return c.name
-- 		end, get_clients())
-- 	end,
-- })
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("Highlight", { clear = true }),
})
-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("help_window_right", {}),
	pattern = { "*.txt" },
	callback = function()
		if vim.o.filetype == "help" then
			vim.cmd.wincmd("L")
		end
	end,
})
-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		vim.notify("Buffer saved!")
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
	vim.notify("Formatting is now disabled for this buffer.")
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
	vim.notify("Formatting is now re-enabled for this buffer.")
end, {
	desc = "Re-enable autoformat-on-save",
})

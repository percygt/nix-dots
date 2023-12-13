vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.wo.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.wrap = false -- display lines as one long line
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- smart case
vim.opt.cmdheight = 0 --- hide command line
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 8
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.syntax = "enable"
vim.cmd([[set iskeyword+=-]])
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local indent_map = {
	c = { tabstop = 2, shiftwidth = 2, expandtab = true },
	cpp = { tabstop = 2, shiftwidth = 2, expandtab = true },
	nix = { tabstop = 2, shiftwidth = 2, expandtab = true },
	json = { tabstop = 2, shiftwidth = 2, expandtab = true },
	terraform = { tabstop = 2, shiftwidth = 2, expandtab = true },
	javascript = { tabstop = 2, shiftwidth = 2, expandtab = true },
	markdown = { tabstop = 2, shiftwidth = 2, expandtab = true },
	html = { tabstop = 2, shiftwidth = 2, expandtab = true },
	python = { tabstop = 2, shiftwidth = 2, expandtab = true },
}
local group = vim.api.nvim_create_augroup("MyCustomIndents", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(indent_map),
	group = group,
	callback = function()
		local match = vim.fn.expand("<amatch>")
		for opt, val in pairs(indent_map[match]) do
			vim.api.nvim_set_option_value(opt, val, { scope = "local" })
		end
	end,
})
vim.cmd("filetype indent plugin on")

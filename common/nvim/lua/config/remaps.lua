local setKey = vim.keymap.set
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }
setKey("", "<leader>", "<Nop>", term_opts)
vim.api.nvim_set_keymap("n", "<leader><leader>", [[:set nohlsearch<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><leader>", [[:so<CR>]], { noremap = true, silent = true })

setKey("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
setKey("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- setKey("n", "<leader>pv", vim.cmd.Ex)
setKey("n", "J", "mzJ`z")
setKey("n", "<C-d>", "<C-d>zz")
setKey("n", "<C-u>", "<C-u>zz")
setKey("n", "n", "nzzzv")
setKey("n", "N", "Nzzzv")
-- Better window navigation
setKey("n", "<C-h>", "<C-w>h", opts)
setKey("n", "<C-j>", "<C-w>j", opts)
setKey("n", "<C-k>", "<C-w>k", opts)
setKey("n", "<C-l>", "<C-w>l", opts)
-- Navigate buffers
setKey("n", "L", ":bnext<CR>", opts)
setKey("n", "H", ":bprevious<CR>", opts)
-- Move text up and down
setKey("n", "<A-j>", ":m .+1<CR>==", opts)
setKey("n", "<A-k>", ":m .-2<CR>==", opts)
setKey({ "x", "v" }, "<A-j>", ":m '>+1<CR>gv=gv", opts)
setKey({ "x", "v" }, "<A-k>", ":m '<-2<CR>gv=gv", opts)
-- Resize with arrows
setKey("n", "<C-Up>", ":resize -2<CR>", opts)
setKey("n", "<C-Down>", ":resize +2<CR>", opts)
setKey("n", "<C-Left>", ":vertical resize -2<CR>", opts)
setKey("n", "<C-Right>", ":vertical resize +2<CR>", opts)
-- Exit insert mode
setKey("i", "jj", "<Esc>", opts)

-- files
setKey("n", "QQ", ":q!<enter>", opts)
setKey("n", "WW", ":w!<enter>", opts)

-- Yank into system clipboard
setKey({ "n", "v" }, "<leader>y", '"+y', opts) -- yank motion
setKey({ "n", "v" }, "<leader>Y", '"+Y', opts) -- yank line

-- Delete into system clipboard
setKey({ "n", "v" }, "<leader>d", '"+d', opts) -- delete motion
setKey({ "n", "v" }, "<leader>D", '"+D', opts) -- delete line

-- Paste from system clipboard
setKey("n", "<leader>p", '"+p', opts) -- paste after cursor
setKey("n", "<leader>P", '"+P', opts) -- paste before cursor

-- greatest remap ever
setKey("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
setKey({ "n", "v" }, "<leader>y", [["+y]])
setKey("n", "<leader>Y", [["+Y]])

setKey({ "n", "v" }, "<leader>d", [["_d]])

setKey("n", "Q", "<nop>")
setKey("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")
setKey("n", "<leader>f", vim.lsp.buf.format)

setKey("n", "<C-k>", ":cnext<CR>zz")
setKey("n", "<C-j>", ":cprev<CR>zz")
setKey("n", "<leader>k", ":lnext<CR>zz")
setKey("n", "<leader>j", ":lprev<CR>zz")

setKey("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
setKey("n", "<leader>x", ":!chmod +x %<CR>", { silent = true })

setKey("n", "<leader>vpp", ":e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
setKey("n", "<leader>mr", ":CellularAutomaton make_it_rain<CR>")

setKey("n", "<leader><leader>", function()
	vim.cmd("so")
end)

local id = vim.api.nvim_create_augroup("startup", {
	clear = false,
})

local persistbuffer = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
			buffer = 0,
			once = true,
			callback = function()
				persistbuffer()
			end,
		})
	end,
})

setKey("n", "<Leader>b", function()
	local curbufnr = vim.api.nvim_get_current_buf()
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
			vim.cmd("bd " .. tostring(bufnr))
		end
	end
end, { silent = true, desc = "Close unused buffers" })

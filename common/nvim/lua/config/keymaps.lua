vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
-- twilight
vim.api.nvim_set_keymap("n", "tw", ":Twilight<enter>", { noremap = false })
-- buffers
vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", { noremap = false })
-- files
vim.api.nvim_set_keymap("n", "QQ", ":q!<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "WW", ":w!<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "E", "$", { noremap = false })
vim.api.nvim_set_keymap("n", "B", "^", { noremap = false })
vim.api.nvim_set_keymap("n", "TT", ":TransparentToggle<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "st", ":TodoTelescope<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "ss", ":noh<CR>", { noremap = true })
-- splits
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", { noremap = true })
vim.keymap.set("n", "<space><space>", "<cmd>set nohlsearch<CR>")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- local remap = vim.api.nvim_set_keymap

-- -- Remove annoying mapping
-- remap("n", "Q", "<Nop>", { noremap = true })

-- -- Quick Fix lists
-- remap("n", "<C-k>", ":cnext<CR>", { noremap = true })
-- remap("n", "<C-j>", ":cprev<CR>", { noremap = true })
-- remap("n", "<C-q>", ":call ToggleQFList(1)<CR>", { noremap = true })
-- remap("n", "<C-l>", ":call ToggleQFList(0)<CR>", { noremap = true })

-- -- Copy and paste
-- remap("v", "<leader>y", '"+y', { noremap = true })
-- remap("n", "<leader>y", '"+yy', { noremap = true })
-- remap("v", "<leader>p", '"+p', { noremap = true })
-- remap("v", "<leader>P", '"+P', { noremap = true })
-- remap("n", "<leader>p", '"+p', { noremap = true })
-- remap("n", "<leader>P", '"+P', { noremap = true })
-- remap("n", "Y", "y$", { noremap = true })

-- -- Add relative jumps to jumplist
-- remap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . \'k\'', { noremap = true, expr = true })
-- remap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . \'j\'', { noremap = true, expr = true })

-- -- Moving text
-- remap("v", "<leader>j", ":m '>+1<CR>gv=gv", { noremap = true })
-- remap("v", "<leader>k", ":m '<-2<CR>gv=gv", { noremap = true })
-- -- remap("i", "<leader>j", "<esc>:m .+1<CR>==", { noremap = true })
-- -- remap("i", "<leader>k", "<esc>:m .-2<CR>==", { noremap = true })
-- remap("n", "<leader>j", ":m .+1<CR>==", { noremap = true })
-- remap("n", "<leader>k", ":m .-2<CR>==", { noremap = true })

-- -- Command shortcuts
-- remap("n", "<leader>F", ":Format<CR>", { noremap = true })

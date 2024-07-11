local keymap = require("config.helpers")
local silent = { silent = true }
local nnoremap = keymap.nnoremap
local xnoremap = keymap.xnoremap
local vnoremap = keymap.xnoremap
local nmap = keymap.nmap
local vmap = keymap.vmap
local imap = keymap.imap
local builtin = require("telescope.builtin")
nmap("<leader>", "<nop>", silent)
vmap("<leader>", "<nop>", silent)
vmap("Q", "<nop>")
-- Quit
nmap("QQ", ":q!<cr>", silent)
-- Format
nnoremap("<a-f>", "<cmd>lua require('conform').format()<cr>", silent)
-- trouble navigation
-- nmap("<a-k>", "<cmd>lua require('trouble').next({ skip_groups = true, jump = true })<cr>zz", silent)
-- nmap("<a-j>", "<cmd>lua require('trouble').previous({ skip_groups = true, jump = true })<cr>zz", silent)

nmap("<enter>", "<cmd>lua require('flash').jump()<cr>", silent)
nmap("<s-enter>", "<cmd>lua require('flash').treesitter()<cr>", silent)
nmap("<a-enter>", "<cmd>lua require('flash').treesitter_search()<cr>", silent)
nmap("<c-enter>", "<cmd>lua require('flash').remote()<cr>", silent)

nmap("gp", "<cmd>lua require('actions-preview').code_actions()<cr>", silent)
vmap("gp", "<cmd>lua require('actions-preview').code_actions()<cr>", silent)
-- Save
nmap("WW", ":w!<cr>", silent)
imap("WW", "<esc>:w!<cr>", silent)
-- Move back to the beginning of line
nmap("<c-b>", "^", silent)
vmap("<c-b>", "^", silent)
-- Move forward to the end of line
nmap("<c-e>", "$", silent)
vmap("<c-e>", "$", silent)
-- Telescope
nnoremap("<c-s>", builtin.buffers, { desc = "Buffers" })
nnoremap("<c-f>", builtin.find_files, { desc = "Files" })
nnoremap("<leader>?", builtin.oldfiles, { desc = "Find recently opened files" })
nnoremap("<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end)
-- nnoremap("<leader>sf", builtin.find_files, { desc = "Files" })
-- nnoremap("<leader>sh", builtin.help_tags, { desc = "Help" })
-- nnoremap("<leader>sw", builtin.grep_string, { desc = "Current word" })
-- nnoremap("<leader>sg", builtin.live_grep, { desc = "Grep" })
-- nnoremap("<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
-- nnoremap("<leader>sb", builtin.buffers, { desc = "Buffers" })
-- nnoremap("<leader>sc", builtin.commands, { desc = "Commands" })
-- nnoremap("<leader>sn", "<cmd>Telescope notify<cr>", { desc = "Notifications" })
-- nnoremap("<leader>su", "<cmd>Telescope undo<cr>", { desc = "Undo tree" })
-- nnoremap("<leader>sl", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
-- nnoremap("<leader>gs", builtin.git_status, { desc = "Git status" })
-- Better vertical motions
nnoremap("<c-d>", "<c-d>zz")
nnoremap("<c-u>", "<c-u>zz")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
-- Pane navigation
nnoremap("<c-h>", "<c-w>h")
nnoremap("<c-j>", "<c-w>j")
nnoremap("<c-k>", "<c-w>k")
nnoremap("<c-l>", "<c-w>l")
-- Resize with arrows
nnoremap("<c-up>", "<cmd>resize -2<cr>")
nnoremap("<c-down>", "<cmd>resize +2<cr>")
nnoremap("<c-left>", "<cmd>vertical resize -2<cr>")
nnoremap("<c-right>", "<cmd>vertical resize +2<cr>")
-- Better indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")
-- Clear search
nnoremap("ss", "<cmd>noh<cr>")
-- Other ways to yank, delete and paste
nnoremap("<leader>y", [["+y]])
vnoremap("<leader>y", [["+y]])
nnoremap("<leader>Y", [["+Y]])
vnoremap("<leader>Y", [["+Y]])
nnoremap("<leader>d", [["_d]])
vnoremap("<leader>d", [["_d]])
xnoremap("<leader>p", [["_dP]])
-- Navigate buffers
nmap("H", "<cmd>bprev<cr>")
nmap("L", "<cmd>bnext<cr>")
nmap("D", "<cmd>bdelete<cr>")
-- Misc
nnoremap("<leader>tw", "<cmd>Twilight<cr>", silent)

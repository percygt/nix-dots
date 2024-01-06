local keymap = require("config.helpers")
local nnoremap = keymap.nnoremap
local inoremap = keymap.inoremap
local xnoremap = keymap.xnoremap
local vnoremap = keymap.xnoremap
local nmap = keymap.nmap
local vmap = keymap.vmap
local silent = { silent = true }

nmap("<leader>", "<nop>", silent)
vmap("<leader>", "<nop>", silent)
vmap("Q", "<nop>")
nmap("QQ", ":q!<cr>", silent)
nmap("WW", ":w!<cr>", silent)
nmap("E", "$")
nmap("B", "^")
-- Exit insert mode
inoremap("jj", "<esc>")
-- Save
inoremap("WW", "<esc>:w!<cr>", silent)
-- Move text up and down
vnoremap("<a-j>", "<cmd>m '>+1<cr>gv=gv", silent)
vnoremap("<a-k>", "<cmd>m '<-2<cr>gv=gv", silent)
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
nnoremap("<leader>mr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
nnoremap("<leader>mx", "<cmd>!chmod +x %<cr>", silent)
nnoremap("<leader>tw", "<cmd>Twilight<cr>", silent)
nnoremap("<leader>tw", "<cmd>Twilight<cr>", silent)
-- Format
nnoremap("<leader><leader>", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", silent)

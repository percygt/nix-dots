local keymap = require("config.utils")
local silent = { silent = true }
local nmap = keymap.nmap
local vmap = keymap.vmap
local imap = keymap.imap
local xmap = keymap.xmap
local cmap = keymap.cmap
local nvmap = keymap.nvmap
vmap("Q", "<nop>", silent)
-- Quit
nmap("QQ", ":q!<cr>", silent)
-- Save
nmap("WW", ":w!<cr>", silent)
imap("WW", "<esc>:w!<cr>", silent)
-- Move back to the beginning of line
nvmap("<c-b>", "^")
-- Move forward to the end of line
nvmap("<c-e>", "$")
-- Insert and command motions
cmap("<c-h>", "<Left>")
cmap("<c-j>", "<Down>")
cmap("<c-k>", "<Up>")
cmap("<c-l>", "<Right>")
imap("<c-h>", "<Left>")
imap("<c-j>", "<Down>")
imap("<c-k>", "<Up>")
imap("<c-l>", "<Right>")
-- Better vertical motions
nmap("<c-d>", "<c-d>zz")
nmap("<c-u>", "<c-u>zz")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")
-- Pane navigation
nmap("<c-h>", "<c-w>h")
nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-l>", "<c-w>l")
-- Resize with arrows
nmap("<c-up>", "<cmd>resize -2<cr>")
nmap("<c-down>", "<cmd>resize +2<cr>")
nmap("<c-left>", "<cmd>vertical resize -2<cr>")
nmap("<c-right>", "<cmd>vertical resize +2<cr>")
-- Clear search
nmap("ss", "<cmd>noh<cr>")
-- Other ways to yank, delete and paste
nvmap("<leader>y", [["+y]])
nmap("<leader>Y", [["+Y]])
nvmap("<leader>d", [["_d]])
xmap("<leader>p", [["_dP]])
-- Navigate buffers
nmap("H", "<cmd>bprev<cr>")
nmap("L", "<cmd>bnext<cr>")
-- Delete buffer
nmap("D", "<cmd>bdelete<cr>")

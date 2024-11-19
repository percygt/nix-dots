local keymap = require("utils")
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
nvmap("<C-b>", "^")
-- Move forward to the end of line
nvmap("<C-e>", "$")
-- Insert and command motions
cmap("<C-h>", "<Left>")
cmap("<C-j>", "<Down>")
cmap("<C-k>", "<Up>")
cmap("<C-l>", "<Right>")
imap("<C-h>", "<Left>")
imap("<C-j>", "<Down>")
imap("<C-k>", "<Up>")
imap("<C-l>", "<Right>")
-- Better vertical motions
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")
-- Pane navigation
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")
-- Resize with arrows
nmap("<C-up>", "<cmd>resize -2<cr>")
nmap("<C-down>", "<cmd>resize +2<cr>")
nmap("<C-left>", "<cmd>vertical resize -2<cr>")
nmap("<C-right>", "<cmd>vertical resize +2<cr>")
-- Clear search
nmap("ss", "<cmd>noh<cr>")
-- Other ways to yank, delete and paste
nvmap("<leader>y", [["+y]])
nmap("<leader>Y", [["+Y]])
nvmap("<leader>d", [["_d]])
xmap("<leader>p", [["_dP]])
-- -- Navigate buffers
nmap("gh", "<cmd>bprev<cr>")
nmap("gl", "<cmd>bnext<cr>")
-- Delete buffer
-- nmap("D", "<cmd>bdelete<cr>")

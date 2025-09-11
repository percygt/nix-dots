local keymap = require("utils")
local nmap = keymap.nmap
local xmap = keymap.xmap
local nvmap = keymap.nvmap

-- Move back to the beginning of line
nvmap("<C-b>", "^")
-- Move forward to the end of line
nvmap("<C-e>", "$")
-- -- Better vertical motions
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")
-- Resize with arrows
nmap("<C-up>", "<cmd>resize -2<cr>")
nmap("<C-down>", "<cmd>resize +2<cr>")
nmap("<C-left>", "<cmd>vertical resize -2<cr>")
nmap("<C-right>", "<cmd>vertical resize +2<cr>")
-- Other ways to yank, delete and paste
nvmap("<leader>y", [["+y]])
nmap("<leader>Y", [["+Y]])
nvmap("<leader>d", [["_d]])
-- xmap("<leader>P", [["_dP]])

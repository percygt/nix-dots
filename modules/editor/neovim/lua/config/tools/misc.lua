require("todo-comments").setup({
  keywords = {
    TODO = { icon = " ", color = "#de9e00" },
  },
})
-- require("mini.comment").setup()
require("Comment").setup()

local keymap = require("config.helpers")
local silent = { silent = true }
local nmap = keymap.nmap
local vmap = keymap.vmap

nmap("<C-w>z", ":MaximizerToggle<CR>", silent)
vmap("<C-w>z", ":MaximizerToggle<CR>", silent)

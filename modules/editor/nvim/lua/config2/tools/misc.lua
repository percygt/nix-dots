require("todo-comments").setup({
  keywords = {
    TODO = { icon = " ", color = "#de9e00" },
  },
})
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
require("neoscroll").setup({
  stop_eof = true,
  easing_function = "sine",
  hide_cursor = true,
  cursor_scrolls_alone = true,
})

require("multicursors").setup({
  hint_config = false,
})
require("neogen").setup({
  snippet_engine = "luasnip",
})
local keymap = require("config.helpers")
local silent = { silent = true }
local nmap = keymap.nmap
local vmap = keymap.vmap

nmap("<C-w>z", ":MaximizerToggle<CR>", silent)
vmap("<C-w>z", ":MaximizerToggle<CR>", silent)

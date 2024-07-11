local wk = require("which-key")
vim.o.timeout = true
vim.o.timeoutlen = 300
wk.setup({
  window = {
    border = "single",
    padding = { 2, 2, 2, 2 },
  },
  triggers_blacklist = {
    n = { "<C-w>", "v", "Q", "W", "s", "," },
    i = { "<C-w>", "W", "j" },
  },
  layout = {
    spacing = 2,
    align = "center",
  },
})

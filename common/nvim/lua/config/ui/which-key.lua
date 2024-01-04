local wk = require("which-key")
vim.o.timeout = true
vim.o.timeoutlen = 300
wk.setup({
  window = {
    border = "single",
    padding = { 2, 2, 2, 2 },
  },
  triggers_blacklist = {
    n = { "v", "Q", "W" },
    i = { "W", "j" },
  },
  layout = {
    spacing = 2,
    align = "center",
  },
})

wk.register({
  c = "Code",
  D = {
    name = "Debug",
    t = { "<cmd>DapUiToggle<Cr>", "Toggle UI" },
    b = { "<cmd>DapToggleBreakpoint<Cr>", "Toggle Breakpoint" },
    c = { "<cmd>DapContinue<Cr>", "Continue" },
    r = { "<cmd>lua require('dapui').open({reset = true})<cr>", "Reset Dapui" },
  },
  d = "which_key_ignore",
  e = { name = "File Explorer" },
  g = { name = "Git" },
  h = { name = "Harpoon" },
  m = { name = "Helper" },
  n = { name = "which_key_ignore", n = "which_key_ignore" },
  S = {
    name = "Database",
    t = { "<cmd>DBUIToggle<cr>", "Toggle UI" },
    f = { "<cmd>DBUIFindBuffer<cr>", "Find buffer" },
    r = { "<cmd>DBUIRenameBuffer<cr>", "Rename buffer" },
    q = { "<cmd>DBUILastQueryInfo<Cr>", "Last query info" },
  },
  f = { name = "Find" },
  t = { name = "Theme" },
  x = { name = "Trouble" },
  ["<tab>"] = { name = "Workspace Session" },
  q = {
    name = "Quicklist",
    k = { "<cmd>copen<cr>", "Open Quickfix List" },
    j = { "<cmd>cclose<cr>", "Close Quickfix List" },
    l = { "<cmd>cnext<cr>", "Next Quickfix List" },
    h = { "<cmd>cprev<cr>", "Previous Quickfix List" },
  },
  w = {
    name = "Loclist",
    k = { "<cmd>lopen<cr>", "Open Location List" },
    j = { "<cmd>lclose<cr>", "Close Location List" },
    l = { "<cmd>lnext<cr>", "Next Location List" },
    h = { "<cmd>lprev<cr>", "Previous Location List" },
  },
  y = "which_key_ignore",
  Y = "which_key_ignore",
  ["/"] = "which_key_ignore",
  ["?"] = "which_key_ignore",
  ["<space>"] = "which_key_ignore",
}, { prefix = "<leader>", mode = "n", silent = true })

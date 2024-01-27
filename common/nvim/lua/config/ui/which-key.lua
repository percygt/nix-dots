local wk = require("which-key")
vim.o.timeout = true
vim.o.timeoutlen = 300
wk.setup({
  window = {
    border = "single",
    padding = { 2, 2, 2, 2 },
  },
  triggers_blacklist = {
    n = { "v", "Q", "W", "s", "f" },
    i = { "W", "j" },
  },
  layout = {
    spacing = 2,
    align = "center",
  },
})

wk.register({
  n = {
    name = "Multicursors",
    n = { "<cmd>MCstart<cr>", "MCstart" },
    v = { "<cmd>MCvisual<cr>", "MCvisual" },
    c = { "<cmd>MCclear<cr>", "MCclear" },
    p = { "<cmd>MCpattern<cr>", "MCpattern" },
    V = { "<cmd>MCvisualPattern<cr>", "MCvisualPattern" },
    u = { "<cmd>MCunderCursor<cr>", "MCunderCursor" },
  },
}, { prefix = "<leader>", mode = "v", silent = true })

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
  f = { name = "Files" },
  g = { name = "Git" },
  m = { name = "Harpoon" },
  h = {
    name = "Helper",
    r = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Multi Replace" },
    x = { "<cmd>!chmod +x %<cr>", "Make executable" },
  },
  n = {
    name = "Multicursors",
    n = { "<cmd>MCstart<cr>", "MCstart" },
    v = { "<cmd>MCvisual<cr>", "MCvisual" },
    c = { "<cmd>MCclear<cr>", "MCclear" },
    p = { "<cmd>MCpattern<cr>", "MCpattern" },
    V = { "<cmd>MCvisualPattern<cr>", "MCvisualPattern" },
    u = { "<cmd>MCunderCursor<cr>", "MCunderCursor" },
  },
  S = {
    name = "Database",
    t = { "<cmd>DBUIToggle<cr>", "Toggle UI" },
    f = { "<cmd>DBUIFindBuffer<cr>", "Find buffer" },
    r = { "<cmd>DBUIRenameBuffer<cr>", "Rename buffer" },
    q = { "<cmd>DBUILastQueryInfo<Cr>", "Last query info" },
  },
  s = { name = "Search" },
  t = { name = "Theme" },
  x = {
    name = "Trouble",
    q = { "<cmd>TroubleToggle quickfix<cr>", "Toggle Quickfix List" },
    l = { "<cmd>TroubleToggle loclist<cr>", "Toggle Loclist" },
    x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Toggle Workspace Diagnostic" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Toggle Document Diagnostic" },
    r = { "<cmd>TroubleRefresh<cr>", "Refresh" },
  },
  -- q = {
  --   name = "Quicklist",
  --   k = { "<cmd>copen<cr>", "Open Quickfix List" },
  --   j = { "<cmd>cclose<cr>", "Close Quickfix List" },
  --   l = { "<cmd>cnext<cr>", "Next Quickfix List" },
  --   h = { "<cmd>cprev<cr>", "Previous Quickfix List" },
  -- },
  -- w = {
  --   name = "Loclist",
  --   k = { "<cmd>lopen<cr>", "Open Location List" },
  --   j = { "<cmd>lclose<cr>", "Close Location List" },
  --   l = { "<cmd>lnext<cr>", "Next Location List" },
  --   h = { "<cmd>lprev<cr>", "Previous Location List" },
  -- },
  y = "which_key_ignore",
  Y = "which_key_ignore",
  ["/"] = "which_key_ignore",
  ["?"] = "which_key_ignore",
  ["<tab>"] = { name = "Session" },
  ["<space>"] = { "<cmd>NoiceDismiss<cr>", "Noice Dismiss" },
}, { prefix = "<leader>", mode = "n", silent = true })

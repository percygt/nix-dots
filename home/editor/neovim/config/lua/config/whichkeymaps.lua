local wk = require("which-key")
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
  m = { "<cmd>lua require('harpoon').ui:toggle_quick_menu(harpoon:list())<cr>", "Harpoon" },
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
  y = "which_key_ignore",
  Y = "which_key_ignore",
  ["/"] = "which_key_ignore",
  ["?"] = "which_key_ignore",
  ["<tab>"] = { name = "Session" },
  ["<space>"] = { "<cmd>NoiceDismiss<cr>", "Noice Dismiss" },
}, { prefix = "<leader>", mode = "n", silent = true })

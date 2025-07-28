return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  enabled = false,
  event = "VeryLazy",
  opts = {
    excluded_lsp_clients = { "nixd" },
    notifications = true,
  },
}

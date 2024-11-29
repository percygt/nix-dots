return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    excluded_lsp_clients = { "nixd", "nil_ls" },
    notifications = true,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = require("config.lsp-servers"),
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function()
      return {
        ensure_installed = {},
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.automatic_installation = false
    end,
  },
}

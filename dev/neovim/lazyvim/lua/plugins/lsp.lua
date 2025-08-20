-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
local masonLsp = { "astro", "volar", "svelte" }
local servers = require("config.lsp-servers")
local function isInMasonServer(server_name)
  for _, name in ipairs(masonLsp) do
    if name == server_name then
      return true
    end
  end
  return false
end
for server_name, server_config in pairs(servers) do
  if not isInMasonServer(server_name) then
    server_config.mason = false
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "ck", "<cmd>LspStop<cr>", desc = "Disable currenly running LSP" },
    },
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = servers,
    },
  },
  {
    "mason-org/mason.nvim",
    version = "1.11.0",
    opts = function()
      return {
        ensure_installed = {},
      }
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "1.32.0",
    opts = function(_, opts)
      opts.automatic_installation = false
    end,
  },
}

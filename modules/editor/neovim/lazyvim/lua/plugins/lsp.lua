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
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = servers,
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

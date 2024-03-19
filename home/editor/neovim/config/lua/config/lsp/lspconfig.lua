local M = {}
local lspconfig = require("lspconfig")
local on_attach = require("config.lsp.on_attach")
local fidget = require("fidget")

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local completion = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
capabilities.textDocument.completion = completion.textDocument.completion

function M.setup_servers(json_config)
  require("neodev").setup({}) -- Automagically sets up lua lsp config

  local f = io.open(json_config, "r")
  if not f then
    return
  end

  local lsp_servers = vim.json.decode(f:read("all*"))
  f:close()
  if lsp_servers == nil then
    return
  end

  for server, config in pairs(lsp_servers) do
    if config.root_pattern and next(config.root_pattern) then
      config.root_dir = lspconfig.util.root_pattern(unpack(config.root_pattern))
      config.root_pattern = nil
    end
    -- if server == "denols" then
    --   config.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
    -- end
    -- if server == "tsserver" then
    --   config.root_dir = lspconfig.util.root_pattern("package.json")
    --   config.single_file_support = false
    -- end
    fidget.setup({
      progress = {
        suppress_on_insert = true, -- Suppress new messages while in insert mode
      },
    })
    config.capabilities = capabilities
    config.on_attach = on_attach
    lspconfig[server].setup(config)
  end
end

return M

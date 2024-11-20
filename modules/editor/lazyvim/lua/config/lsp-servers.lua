return {
  jsonls = {},
  terraformls = {
    cmd = { "terraform-ls" },
    arg = { "server" },
    filetypes = { "terraform", "tf", "terraform-vars" },
  },
  pylsp = {},
  neocmake = {},
  clojure_lsp = {},
  clangd = {},
  nushell = {},
  nil_ls = {},
  nixd = {
    cmd = { "nixd" },
    on_init = function(client, _)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
  dockerls = {},
  bashls = {
    filetypes = { "sh" },
  },
  vimls = {
    filetypes = { "vim" },
  },
  denols = {
    root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
  },
  astro = {},
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
  },
  zls = {},
  gopls = {},
  marksman = {},
  taplo = {},
  cssls = {},
  lua_ls = {
    init_options = {
      documentFormatting = false,
    },
  },
}

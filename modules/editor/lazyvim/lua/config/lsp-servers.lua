return {
  jsonls = {
    mason = false,
  },
  terraformls = {
    mason = false,
    cmd = { "terraform-ls" },
    arg = { "server" },
    filetypes = { "terraform", "tf", "terraform-vars" },
  },
  pylsp = {
    mason = false,
  },
  clojure_lsp = {
    mason = false,
  },
  clangd = {
    mason = false,
  },
  nushell = {
    mason = false,
  },
  nil_ls = {
    mason = false,
  },
  nixd = {
    mason = false,
    cmd = { "nixd" },
    on_init = function(client, _)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
  dockerls = {
    mason = false,
  },
  bashls = {
    mason = false,
    filetypes = { "sh" },
  },
  vimls = {
    mason = false,
    filetypes = { "vim" },
  },
  denols = {
    mason = false,
    root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
  },
  ts_ls = {
    mason = false,
    documentFormatting = false,
    single_file_support = false,
    hostInfo = "neovim",
    root_dir = require("lspconfig").util.root_pattern("package.json"),
  },
  astro = {},
  yamlls = {
    mason = false,
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
  },
  zls = {
    mason = false,
  },
  gopls = {
    mason = false,
  },

  marksman = {
    mason = false,
  },
  taplo = {
    mason = false,
  },
  cssls = {
    mason = false,
  },
  lua_ls = {
    mason = false,
    init_options = {
      documentFormatting = false,
    },
  },
}

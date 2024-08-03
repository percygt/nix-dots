return {
  jsonls = {},
  terraformls = {
    cmd = { "terraform-ls" },
    arg = { "server" },
    filetypes = { "terraform", "tf", "terraform-vars" },
  },
  pylsp = {
    plugins = {
      ruff = {
        enabled = true,
        extendSelect = { "I" },
      },
      -- pylsp_mypy = {
      -- 	enabled = true,
      -- 	report_progress = true,
      -- 	live_mode = false,
      -- },
      jedi_completion = { fuzzy = true },
      black = { enabled = false },
      pyls_isort = { enabled = false },
      pylint = { enabled = false },
    },
  },
  clojure_lsp = {},
  clangd = {},
  nil_ls = {},
  nixd = {
    cmd = { "nixd" },
    on_init = function(client, _)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
  dockerls = {},
  bashls = {
    filetypes = { "sh", "zsh" },
  },
  vimls = {
    filetypes = { "vim" },
  },
  denols = {
    root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
  },
  tsserver = {
    documentFormatting = false,
    single_file_support = false,
    hostInfo = "neovim",
    root_dir = require("lspconfig").util.root_pattern("package.json"),
  },
  astro = {},
  solidity_ls_nomicfoundation = {},
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

require("lazy").setup({
  spec = {
    {
      name = "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.lang.nix" },
    { import = "lazyvim.plugins.extras.editor.mini-files" },
    { import = "lazyvim.plugins.extras.coding.neogen" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    { import = "lazyvim.plugins.extras.editor.navic" },
    { import = "lazyvim.plugins.extras.lang.astro" },
    { import = "lazyvim.plugins.extras.lang.clojure" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.nix" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "plugins" },
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    { "folke/persistence.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    -- { "williamboman/mason.nvim", enabled = false },
    -- { "williamboman/mason-lspconfig.nvim", enabled = false },
  },
  install = {
    missing = true,
    colorscheme = { "onedark", "habamax" },
  },
  rocks = { enabled = false },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

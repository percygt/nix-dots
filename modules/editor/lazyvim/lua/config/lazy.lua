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
    -- { import = "lazyvim.plugins.extras.editor.harpoon2" },
    { import = "plugins" },
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    { "folke/persistence.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    -- {
    --   "hrsh7th/nvim-cmp",
    --   url = "https://github.com/iguanacucumber/magazine.nvim",
    -- },
    -- {
    --   "hrsh7th/cmp-nvim-lua",
    --   url = "https://github.com/iguanacucumber/mag-nvim-lua",
    -- },
    -- {
    --   "hrsh7th/cmp-nvim-lsp",
    --   url = "https://github.com/iguanacucumber/mag-nvim-lsp",
    -- },
    -- {
    --   "hrsh7th/cmp-buffer",
    --   url = "https://github.com/iguanacucumber/mag-buffer",
    -- },
    -- {
    --   "hrsh7th/cmp-cmdline",
    --   url = "https://github.com/iguanacucumber/mag-cmdline",
    -- },
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

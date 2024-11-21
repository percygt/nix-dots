local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lsp.neoconf" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.editor.mini-files" },
    { import = "lazyvim.plugins.extras.coding.neogen" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    { import = "lazyvim.plugins.extras.editor.navic" },
    -- language support
    { import = "lazyvim.plugins.extras.lang.astro" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.vue" },
    { import = "lazyvim.plugins.extras.lang.svelte" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.clojure" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.sql" },
    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "plugins" },
    { "folke/persistence.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  },
  install = {
    missing = true,
    colorscheme = { "catppuccin", "onedark" },
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

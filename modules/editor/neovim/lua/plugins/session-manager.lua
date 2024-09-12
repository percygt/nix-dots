return {
  "Shatur/neovim-session-manager",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  keys = {
    { "<leader><tab>", "", desc = "+SessionManager", mode = { "n", "v" } },
    { "<leader><tab>r", "<cmd>SessionManager load_current_dir_session<cr>", desc = "Restore session" },
    { "<leader><tab>w", "<cmd>SessionManager save_current_session<cr>", desc = "Save current session" },
    { "<leader><tab>l", "<cmd>SessionManager load_session<cr>", desc = "List all session" },
    { "<leader><tab>d", "<cmd>SessionManager delete_session<cr>", desc = "Delete session" },
  },
  config = function()
    local config = require("session_manager.config")
    local home = os.getenv("HOME")
    require("session_manager").setup({
      autoload_mode = { config.AutoloadMode.CurrentDir, config.AutoloadMode.GitSession },
      autosave_last_session = true,
      autosave_ignore_not_normal = false,
      autosave_ignore_dirs = {
        home .. "/downloads",
      },
    })
  end,
}

local config = require("session_manager.config")
local home = os.getenv("HOME")
require("session_manager").setup({
  autoload_mode = config.AutoloadMode.CurrentDir,
  autosave_ignore_dirs = {
    "/",
    home,
    home .. "/Downloads",
    home .. "/Documents",
    home .. "/.config",
    home .. "/.local",
  },
})

local keymap = require("config.keymap")
local nnoremap = keymap.nnoremap

nnoremap("<leader><tab>r", "<cmd>SessionManager load_current_dir_session<cr>", { desc = "Restore session" }) -- restore last workspace session for current directory
nnoremap("<leader><tab>w", "<cmd>SessionManager save_current_session<cr>", { desc = "Save current session" }) -- save workspace session for current working directory
nnoremap("<leader><tab>l", "<cmd>SessionManager load_session<cr>", { desc = "List all sessions" }) -- save workspace session for current working directory
nnoremap("<leader><tab>d", "<cmd>SessionManager delete_session<cr>", { desc = "Delete session" }) -- save workspace session for current working directory

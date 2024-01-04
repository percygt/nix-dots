local auto_session = require("auto-session")
local session_lens = require("auto-session.session-lens")
auto_session.setup({
  auto_restore_enabled = true,
  auto_save_enabled = true,
  auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "/" },
  auto_session_root_dir = vim.fn.stdpath("data") .. "/session/",
})

local keymap = require("config.keymap")
local nnoremap = keymap.nnoremap

nnoremap("<leader><tab>r", "<cmd>SessionRestore<cr>", { desc = "Restore session" }) -- restore last workspace session for current directory
nnoremap("<leader><tab>w", "<cmd>SessionSave<cr>", { desc = "Save session" }) -- save workspace session for current working directory
nnoremap("<leader><tab>s", session_lens.search_session, { desc = "Search sessions" }) -- Search session

local auto_session = require("auto-session")
local session_lens = require("auto-session.session-lens")
auto_session.setup({
  auto_restore_enabled = false,
  auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
  session_lens = {
    -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
    buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
    load_on_setup = true,
    theme_conf = { border = true },
    previewer = true,
  },
})

local keymap = require("config.keymap")
local nnoremap = keymap.nnoremap

nnoremap("<leader><tab>r", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })             -- restore last workspace session for current directory
nnoremap("<leader><tab>s", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
nnoremap("<leader><tab>l", session_lens.search_session, { desc = "Search session" })                    -- Search session

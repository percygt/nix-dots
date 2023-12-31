local auto_session = require("auto-session")

auto_session.setup({
	auto_restore_enabled = false,
	auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
})

local setKey = vim.keymap.set

setKey("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })             -- restore last workspace session for current directory
setKey("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory

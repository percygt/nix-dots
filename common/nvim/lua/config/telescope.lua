local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local extensions = require("telescope").extensions
local keymap = require("config.keymap")
local nnoremap = keymap.nnoremap

telescope.load_extension("file_browser")
telescope.load_extension("git_worktree")
telescope.load_extension("fzf")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
})

-- See `:help telescope.builtin`
nnoremap("<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
nnoremap("<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Fuzzily search in current buffer" })

nnoremap("<leader>sf", builtin.find_files, { desc = "Files" })
nnoremap("<leader>sh", builtin.help_tags, { desc = "Help" })
nnoremap("<leader>sw", builtin.grep_string, { desc = "Current word" })
nnoremap("<leader>sg", builtin.live_grep, { desc = "Grep" })
nnoremap("<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
nnoremap("<leader>sb", builtin.buffers, { desc = "Buffers" })
nnoremap("<leader>sc", builtin.commands, { desc = "Commands" })
nnoremap("<leader>sn", extensions.notify.notify, { desc = "Notifications" })
nnoremap("<leader>ee", extensions.file_browser.file_browser, { desc = "File Browser" })
nnoremap("<leader>gs", builtin.git_status, { desc = "Git status" })
nnoremap("<leader>gwl", extensions.git_worktree.git_worktrees, { desc = "Worktree list" })
nnoremap("<leader>gwc", extensions.git_worktree.create_git_worktree, { desc = "Create worktree" })

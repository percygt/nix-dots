local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.load_extension("file_browser")
telescope.load_extension("git_worktree")
telescope.load_extension("fzf")
telescope.load_extension("undo")

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
  pickers = {
    find_files = {
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "-g",
        "!.git",
      },
    },
  },
})

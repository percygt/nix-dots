local telescope = require("telescope")
local actions = require("telescope.actions")

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
  extensions = {
    file_browser = {
      theme = "ivy",
    },
    undo = {
      side_by_side = true,
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.8,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
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

telescope.load_extension("file_browser")
telescope.load_extension("git_worktree")
telescope.load_extension("fzf")
telescope.load_extension("undo")

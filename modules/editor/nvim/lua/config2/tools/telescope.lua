local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.sources.telescope")
local icons = require("config.ui.icons")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-t>"] = trouble.open,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = { ["<C-t>"] = trouble.open },
    },
    path_display = {
      "filename_first",
    },
    previewer = false,
    prompt_prefix = " " .. icons.ui.Telescope .. " ",
    selection_caret = icons.ui.BoldArrowRight .. " ",
    file_ignore_patterns = { "node_modules", "package-lock.json" },
    initial_mode = "insert",
    select_strategy = "reset",
    sorting_strategy = "ascending",
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    layout_config = {
      prompt_position = "top",
      preview_cutoff = 120,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        previewer = false,
        initial_mode = "normal",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.5,
            height = 0.4,
            preview_width = 0.6,
          },
        },
      }),
    },
  },
  pickers = {
    find_files = {
      previewer = false,
      -- path_display = formattedName,
      layout_config = {
        height = 0.4,
        prompt_position = "top",
        preview_cutoff = 120,
      },
    },
    git_files = {
      previewer = false,
      -- path_display = formattedName,
      layout_config = {
        height = 0.4,
        prompt_position = "top",
        preview_cutoff = 120,
      },
    },
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["<c-d>"] = actions.delete_buffer,
        },
      },
      previewer = false,
      initial_mode = "normal",
      -- theme = "dropdown",
      layout_config = {
        height = 0.4,
        width = 0.6,
        prompt_position = "top",
        preview_cutoff = 120,
      },
    },
    current_buffer_fuzzy_find = {
      previewer = true,
      layout_config = {
        prompt_position = "top",
        preview_cutoff = 120,
      },
    },
    live_grep = {
      only_sort_text = true,
      previewer = true,
    },
    grep_string = {
      only_sort_text = true,
      previewer = true,
    },
    lsp_references = {
      show_line = false,
      previewer = true,
    },
    treesitter = {
      show_line = false,
      previewer = true,
    },
    colorscheme = {
      enable_preview = true,
    },
  },
})

telescope.load_extension("git_worktree")
telescope.load_extension("ui-select")
telescope.load_extension("notify")
telescope.load_extension("fzf")
telescope.load_extension("undo")

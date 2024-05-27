local treesitter = require("nvim-treesitter.configs")
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

treesitter.setup({
  auto_install = false, -- Parsers are managed by Nix
  indent = {
    enable = true,
    disable = { "python", "yaml" }, -- Yaml and Python indents are unusable
  },
  highlight = {
    enable = true,
    disable = { "yaml" },
    additional_vim_regex_highlighting = false,
  },
  autopairs = { enable = true },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["ak"] = "@block.outer",
        ["ik"] = "@block.inner",
        ["is"] = "@statement.inner",
        ["as"] = "@statement.outer",
        ["am"] = "@call.outer",
        ["im"] = "@call.inner",
        ["at"] = "@comment.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["(a"] = "@parameter.inner",
      },
      swap_previous = {
        ["(A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})

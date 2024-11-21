return {
  {
    "folke/twilight.nvim",
    event = "VeryLazy",
    lazy = true,
    keys = {
      { "<a-T>", "<cmd>Twilight<cr>", desc = "Twilight", silent = true },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = true,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { "brenoprata10/nvim-highlight-colors", event = "BufReadPost", opts = { render = "virtual" } },
  {
    "max397574/better-escape.nvim",
    opts = {
      mappings = {
        v = {
          j = {
            k = false,
          },
        },
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    opts = {
      stop_eof = true,
      easing_function = "sine",
      hide_cursor = true,
      cursor_scrolls_alone = true,
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-u>",
        "<C-d>",
        "<C-f>",
        "<C-y>",
        "zt",
        "zz",
        "zb",
      },
    },
  },
  -- Lua
  {
    "szw/vim-maximizer",
    lazy = true,
    keys = {
      { "<c-w>z", "<cmd>MaximizerToggle<cr>", desc = "Window maximizer toggle", mode = { "n", "v" } },
    },
  },
}

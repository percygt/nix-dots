return {
  "echasnovski/mini.files",
  init = function()
    -- delete lazygit keymap for file history
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimKeymaps",
      once = true,
      callback = function()
        pcall(vim.keymap.del, "n", "<leader>fn")
        pcall(vim.keymap.del, "n", "<leader>ft")
        pcall(vim.keymap.del, "n", "<leader>fT")
      end,
    })
  end,
  keys = {
    { "<leader>fm", false },
    { "<leader>fM", false },
    {
      "<leader>f",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Files",
    },
    {
      "<leader>F",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Files (cwd)",
    },
  },
  opts = function(_, opts)
    opts.options = {
      use_as_default_explorer = true,
    }
    opts.windows = {
      max_number = math.huge,
      preview = true,
      width_focus = 60,
      width_nofocus = 15,
      width_preview = 125,
    }
    opts.mappings = {
      close = "q",
      go_in = "L",
      go_in_plus = "l",
    }
  end,
}

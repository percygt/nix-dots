return {
  "folke/snacks.nvim",
  keys = {
    {
      "<c-_>",
      function()
        Snacks.terminal(nil, {
          cwd = vim.fn.expand("%:p:h"),
        })
      end,
      desc = "Toggle Terminal (cwd)",
    },
  },
  opts = {
    terminal = {
      shell = "nu",
      cwd = vim.fn.expand("%:p:h"),
    },
  },
}

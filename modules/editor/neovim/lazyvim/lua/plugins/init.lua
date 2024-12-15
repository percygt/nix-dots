return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimKeymaps",
        once = true,
        callback = function()
          pcall(vim.keymap.del, "n", "<leader>-")
          pcall(vim.keymap.del, "n", "<leader>|")
          pcall(vim.keymap.del, "n", "<leader>K")
          pcall(vim.keymap.del, "n", "<leader>qq")
          pcall(vim.keymap.del, "n", "<leader><tab>l")
          pcall(vim.keymap.del, "n", "<leader><tab>o")
          pcall(vim.keymap.del, "n", "<leader><tab>f")
          pcall(vim.keymap.del, "n", "<leader><tab><tab>")
          pcall(vim.keymap.del, "n", "<leader><tab>]")
          pcall(vim.keymap.del, "n", "<leader><tab>d")
          pcall(vim.keymap.del, "n", "<leader><tab>[")
        end,
      })
    end,
    keys = {
      { "<leader>.", "<c-6>", desc = "Previous buffer" },
    },
    opts = {
      colorscheme = function()
        require("catppuccin").load()
      end,
      icons = {
        kinds = require("config.icons").kind,
        diagnostics = require("config.icons").diagnostics,
        git = require("config.icons").git,
      },
    },
  },
}

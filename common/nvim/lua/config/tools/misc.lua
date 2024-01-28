require("todo-comments").setup({
  keywords = {
    TODO = { icon = " ", color = "#de9e00" },
  },
})
-- require("mini.comment").setup()
require("Comment").setup()
vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true })

require("smartcolumn").setup({
  colorcolumn = "100",
  { python = "120" },
})
require("trouble").setup()
require("twilight").setup()
require("colorizer").setup({
  user_default_options = {
    names = false,
    css_fn = true,
    mode = "virtualtext",
    sass = { enable = true },
  },
})
require("dressing").setup()
require("notify").setup({
  background_colour = "#000000",
  enabled = false,
})
require("noice").setup({
  -- add any options here
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "%d fewer lines" },
          { find = "%d more lines" },
        },
      },
      opts = { skip = true },
    },
  },
})
vim.api.nvim_set_keymap("n", "<leader>nn", ":NoiceDismiss<CR>", { noremap = true, silent = true })

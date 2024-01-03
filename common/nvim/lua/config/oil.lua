require("oil").setup {
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  delete_to_trash = true,
  float = {
    padding = 4,
    max_width = 100,
    max_height = 50,
    border = "rounded",
    win_options = {
      winblend = 10,
    },
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
  },
}
vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "Open Parent Directory" })

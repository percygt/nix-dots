return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>ss",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Snipe",
    },
  },
  opts = {},
}

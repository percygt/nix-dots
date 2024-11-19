return {
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = { "│" },
      highlight = "LineNrNC",
    },
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = "BufReadPost",
    opts = {
      colorcolumn = "100",
      { python = "120" },
    },
  },
}

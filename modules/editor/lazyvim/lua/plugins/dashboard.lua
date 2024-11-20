return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {

        sections = {
          {
            section = "terminal",
            cmd = "sh -c 'chafa "
              .. vim.fn.stdpath("config")
              .. "/lua/config/coffee.jpg"
              .. " --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1'",
            height = 17,
            padding = 1,
          },
          {
            pane = 2,
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
      },
    },
  },
}

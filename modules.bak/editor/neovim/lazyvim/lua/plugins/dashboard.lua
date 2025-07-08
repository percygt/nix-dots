return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            cmd = "fortune -s | cowsay",
            hl = "header",
            random = 20,
            indent = 3,
            height = 14,
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

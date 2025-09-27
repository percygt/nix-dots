return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        width = 18,
        preset = {
          keys = {
            { icon = "", key = "f", desc = " ̲find file", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "", key = "n", desc = " ̲new file", action = ":ene | startinsert" },
            { icon = "", key = "g", desc = " ̲grep text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "", key = "r", desc = " ̲recent file", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = "",
              key = "c",
              desc = " ̲config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = "", key = "s", desc = " ̲session", action = "<cmd>SessionManager load_session<cr>" },
            { icon = "", key = "L", desc = " ̲Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = "", key = "q", desc = " ̲quit", action = ":qa" },
          },
          header = [[
      ████ ██████           █████      ██                 btw
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
]],
        },
        formats = {
          key = { "" },
        },
      },
    },
  },
}

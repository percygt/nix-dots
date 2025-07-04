return {
  "folke/flash.nvim",
  opts = {
    modes = {
      char = {
        enabled = true,
        keys = { "f", "F", "t", "T" },
        char_actions = function(motion)
          return {
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        highlight = { backdrop = false },
      },
    },
  },
}

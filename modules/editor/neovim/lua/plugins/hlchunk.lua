return {
  "shellRaining/hlchunk.nvim",
  opts = function()
    local c = require("config.colorscheme")
    return {
      chunk = {
        enable = true,
        priority = 15,
        style = {
          { fg = c.base0A },
          { fg = c.base08 },
        },
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "─",
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
        -- animation related
        duration = 100,
        delay = 100,
      },
      indent = {
        enable = true,
        style = { c.base03 },
        chars = {
          "│",
        },
      },
    }
  end,
}

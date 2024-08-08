return {
  {
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
        -- NOTE: buggy -- using indent-blankline as replacement
        -- indent = {
        --   enable = true,
        --   style = { c.base03 },
        --   chars = {
        --     "│",
        --   },
        -- },
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    main = "ibl",
    opts = {
      scope = {
        enabled = false,
      },
      indent = {
        char = "│",
        smart_indent_cap = true,
        highlight = "IndentBlack",
      },
    },
    config = function(_, opts)
      local c = require("config.colorscheme")
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IndentBlack", { fg = c.base03 })
      end)
      require("ibl").setup(opts)
    end,
  },
}

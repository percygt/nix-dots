return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        animate = {
          enabled = false,
        },
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = "─",
          },
        },
      },
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    lazy = true,
    enabled = false,
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
      exclude = {
        filetypes = {
          "Trouble",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
          "toggleterm",
          "trouble",
        },
      },
    },
    config = function(_, opts)
      local c = require("config.colorscheme")
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IndentBlack", { fg = c.base03 })
      end)
      Snacks.toggle({
        name = "Indention Guides",
        get = function()
          return require("ibl.config").get_config(0).enabled
        end,
        set = function(state)
          require("ibl").setup_buffer(0, { enabled = state })
        end,
      }):map("<leader>ug")
      require("ibl").setup(opts)
    end,
  },
}

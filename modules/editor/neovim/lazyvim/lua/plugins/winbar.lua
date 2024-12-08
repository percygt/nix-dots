return {
  {
    "Bekaboo/dropbar.nvim",
    event = "LazyFile",
    -- enabled = false,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      {
        "<leader>D",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Winbar pick",
      },
    },
    opts = function()
      local menu_utils = require("dropbar.utils.menu")

      -- Closes all the windows in the current dropbar.
      local function close()
        local menu = menu_utils.get_current()
        while menu and menu.prev_menu do
          menu = menu.prev_menu
        end
        if menu then
          menu:close()
        end
      end

      return {
        icons = {
          kinds = { dir_icon = "" },
        },
        menu = {
          preview = false,
          keymaps = {
            -- Navigate back to the parent menu.
            ["h"] = "<C-w>q",
            -- Expands the entry if possible.
            ["l"] = function()
              local menu = menu_utils.get_current()
              if not menu then
                return
              end
              local row = vim.api.nvim_win_get_cursor(menu.win)[1]
              local component = menu.entries[row]:first_clickable()
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["q"] = close,
            ["<esc>"] = close,
          },
        },
      }
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
      {
        "echasnovski/mini.icons",
        version = false,
        init = function() end,
      },
    },
    init = function()
      vim.opt.updatetime = 200
    end,
    opts = function()
      local c = require("config.colorscheme")
      return {
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        attach_navic = false,
        theme = {
          normal = {
            bg = "NONE",
            fg = c.base04,
          },
          ellipsis = { fg = c.base04 }, -- Conceal's or Normal's fg
          separator = { fg = c.base0D }, -- Conceal's or Normal's fg
          modified = { fg = c.base0B }, -- BufferVisibleMod's fg (a base0A color)
          dirname = { fg = c.base03 },
          basename = { fg = c.base0B },
          context = {},
          context_file = { fg = c.base0D }, -- CmpItemKindFile's fg
          context_module = { fg = c.base09 }, -- CmpItemKindModule's fg
          context_namespace = { fg = c.base09 }, -- CmpItemKindModule's fg
          context_package = { fg = c.base09 }, -- CmpItemKindModule's fg
          context_class = { fg = c.base0A }, -- CmpItemKindClass's fg
          context_method = { fg = c.base0D }, -- CmpItemKindMethod's fg
          context_property = { fg = c.base0C }, -- CmpItemKindProperty's fg
          context_field = { fg = c.base0E }, -- CmpItemKindField's fg
          context_constructor = { fg = c.base0D }, -- CmpItemKindConstructor's fg
          context_enum = { fg = c.base0E }, -- CmpItemKindEnum's fg
          context_interface = { fg = c.base0B }, -- CmpItemKindInterface's fg
          context_function = { fg = c.base0D }, -- CmpItemKindFunction's fg
          context_variable = { fg = c.base0E }, -- CmpItemKindVariable's fg
          context_constant = { fg = c.base09 }, -- CmpItemKindConstant's fg
          context_string = { fg = c.base0B }, -- String's fg
          context_number = { fg = c.base09 }, -- Number's fg
          context_boolean = { fg = c.base09 }, -- Boolean's fg
          context_array = { fg = c.base0E }, -- CmpItemKindStruct's fg
          context_object = { fg = c.base0E }, -- CmpItemKindStruct's fg
          context_key = { fg = c.base0E }, -- CmpItemKindVariable's fg
          context_null = { fg = c.base08 }, -- Special's fg
          context_enum_member = { fg = c.base0A }, -- CmpItemKindEnumMember's fg
          context_struct = { fg = c.base0E }, -- CmpItemKindStruct's fg
          context_event = { fg = c.base0A }, -- CmpItemKindEvent's fg
          context_operator = { fg = c.base08 }, -- CmpItemKindOperator's fg
          context_type_parameter = { fg = c.base08 }, -- CmpItemKindTypeParameter's fg
        },
      }
    end,
    config = function(_, opts)
      require("barbecue").setup(opts)
      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },
}

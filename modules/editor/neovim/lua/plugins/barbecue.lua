return {
  {

    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      { "nvim-tree/nvim-web-devicons", version = "v0.100" }, -- optional dependency
    },
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
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(a)
          local client = vim.lsp.get_client_by_id(a.data.client_id)
          -- don't use nixd as navic lsp provider
          if client.server_capabilities["documentSymbolProvider"] and (client.name ~= "nixd") then
            require("nvim-navic").attach(client, a.buf)
          end
        end,
      })
    end,
  },
}

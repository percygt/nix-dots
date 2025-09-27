return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local c = require("config.colors")
      local custom = {
        inactive = {
          a = { fg = c.base03, bg = c.base01 },
          b = { bg = c.base00 },
          c = { bg = c.base00 },
        },
        normal = {
          a = { fg = c.base01, bg = c.base16 },
          b = { bg = c.base01 },
          c = { bg = c.base01 },
        },
        visual = { a = { fg = c.base01, bg = c.base15 } },
        insert = { a = { fg = c.base05, bg = c.base11 } },
      }
      local icons = LazyVim.config.icons
      opts.options.theme = custom
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "|", right = "|" }
      opts.sections.lualine_a = {
        { "branch", icon = "" },
      }
      opts.sections.lualine_b = {
        -- stylua: ignore
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      }
      opts.sections.lualine_c = {
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
          diff_color = {
            added = { fg = c.base0B },
            modified = { fg = c.base13 },
            removed = { fg = c.base08 },
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        -- stylua: ignore
        {
          function() return require("noice").api.status.search.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        {
          "selectioncount",
          fmt = function(count)
            if count == "" then
              return ""
            end
            return "[" .. count .. "]"
          end,
        },
      }

      opts.sections.lualine_x = {
        Snacks.profiler.status(),
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = function() return { fg = Snacks.util.color("Debug") } end,
        },
        -- stylua: ignore
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = function() return { fg = Snacks.util.color("Special") } end,
        },
      }
      opts.sections.lualine_y = {
        {
          function()
            local buf_clients = nil
            buf_clients = vim.lsp.get_clients({ bufnr = 0 })
            local buf_client_names = {}
            local lsp_count = 0
            for _, client in pairs(buf_clients) do
              table.insert(buf_client_names, client.name)
              lsp_count = lsp_count + 1
            end
            if lsp_count > 1 then
              return table.concat(buf_client_names, "|")
            end
            return buf_client_names[1]
          end,
          color = { fg = c.base13 },
        },
      }
      opts.sections.lualine_z = {
        { "progress", separator = " ", padding = { left = 1, right = 1 } },
      }
      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_y = {},
        lualine_z = {},
      }
    end,
  },
}

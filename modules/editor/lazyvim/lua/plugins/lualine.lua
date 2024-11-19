return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function(_, opts)
      local c = require("config.colorscheme")

      local custom = {
        inactive = {
          a = { fg = c.base03, bg = c.base01 },
          b = { bg = c.base00 },
          c = { bg = c.base00 },
        },
        normal = {
          a = { fg = c.base15, bg = c.base02 },
          b = { bg = c.base10 },
          c = { bg = c.base10 },
        },
        visual = { a = { fg = c.base10, bg = c.base16 } },
        insert = { a = { fg = c.base05, bg = c.base03 } },
      }
      -- color for lualine progress
      vim.api.nvim_set_hl(0, "progressHl1", { fg = c.base06 })
      vim.api.nvim_set_hl(0, "progressHl2", { fg = c.base09 })
      vim.api.nvim_set_hl(0, "progressHl3", { fg = c.base0A })
      vim.api.nvim_set_hl(0, "progressHl4", { fg = c.base0B })
      vim.api.nvim_set_hl(0, "progressHl5", { fg = c.base0C })
      vim.api.nvim_set_hl(0, "progressHl6", { fg = c.base0D })
      vim.api.nvim_set_hl(0, "progressHl7", { fg = c.base0E })

      local function is_active()
        local ok, hydra = pcall(require, "hydra.statusline")
        return ok and hydra.is_active()
      end

      local function get_name()
        local ok, hydra = pcall(require, "hydra.statusline")
        if ok then
          return hydra.get_name()
        end
        return ""
      end

      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons
      require("lualine").setup({
        options = {
          theme = custom,
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "|", right = "|" },
          disabled_filetypes = opts.disabled_filetypes,
        },
        sections = {
          lualine_a = {
            { "branch", icon = "" },
          },
          lualine_b = {
            -- { "harpoon2" },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = {
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

            { get_name, cond = is_active },
            -- stylua: ignore
            {
              function() return require("noice").api.status.search.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() end,
              color = function() return LazyVim.ui.fg("Constant") end,
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
          },

          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return LazyVim.ui.fg("Statement") end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return LazyVim.ui.fg("Constant") end,
            },
            -- stylua: ignore
           {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return LazyVim.ui.fg("Debug") end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return LazyVim.ui.fg("Special") end,
            },
          },
          lualine_y = {
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
          },
          lualine_z = {
            {
              "progress",
              color = function()
                return {
                  fg = vim.fn.synIDattr(
                    vim.fn.synIDtrans(
                      vim.fn.hlID("progressHl" .. (math.floor(((vim.fn.line(".") / vim.fn.line("$")) / 0.17))) + 1)
                    ),
                    "fg"
                  ),
                }
              end,
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          -- lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "neo-tree", "lazy" },
      })
    end,
  },
  -- {
  --   "letieu/harpoon-lualine",
  --   dependencies = {
  --     {
  --       "ThePrimeagen/harpoon",
  --       branch = "harpoon2",
  --     },
  --   },
  -- },
}

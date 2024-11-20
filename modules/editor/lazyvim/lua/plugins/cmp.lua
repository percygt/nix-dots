return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-path", enabled = false },
      "hrsh7th/cmp-emoji",
      -- "cmp-nvim-lua",
      "FelipeLema/cmp-async-path",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      for i, source in ipairs(opts.sources) do
        if source.name == "path" then
          table.remove(opts.sources, i)
          break -- Exit the loop after removing the item
        end
      end
      table.insert(opts.sources, { name = "async_path", priority_weight = 110 })
      -- table.insert(opts.sources, { name = "nvim_lua" })
      table.insert(opts.sources, { name = "emoji" })

      local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      opts.preselect = cmp.PreselectMode.None
      opts.completion = {
        completeopt = "menu,menuone,preview,noselect",
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      opts.window = {
        completion = cmp.config.window.bordered({
          border = border,
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          scrollbar = false,
          sidePadding = 0,
        }),
        documentation = cmp.config.window.bordered({
          documentation = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            border = border,
          },
        }),
      }
      opts.formatting = {
        format = function(entry, item)
          local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
          local icons = LazyVim.config.icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }
          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            end
          end
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
      }
    end,
  },
  {
    "petertriho/cmp-git",
    "davidsierradz/cmp-conventionalcommits",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources(
          { { name = "conventionalcommits" }, { name = "cmp_git" } },
          { { name = "buffer" } }
        ),
      })
      require("cmp_git").setup()
    end,
  },
  {
    "hrsh7th/cmp-cmdline",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "CmdlineEnter",
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          -- disables autocomplete
          ["<esc>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
          ["<cr>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
        }),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          -- disables autocomplete
          ["<cr>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
        }),
        sources = cmp.config.sources({
          { name = "async_path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
}

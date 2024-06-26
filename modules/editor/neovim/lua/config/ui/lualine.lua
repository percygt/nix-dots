local colors = require("onedark.colors")
local mode = require("config.helpers")
local customOneDark = {
  inactive = {
    a = { fg = colors.gray, bg = colors.bg0, gui = "bold" },
    b = { fg = colors.gray, bg = colors.bg0 },
    c = { fg = colors.gray, bg = colors.none },
  },
  normal = {
    a = { fg = colors.bg0, bg = colors.lavender, gui = "bold" },
    b = { fg = colors.fg, bg = colors.bg3 },
    c = { fg = colors.fg, bg = colors.none },
  },
  visual = { a = { fg = colors.bg0, bg = colors.rosewater, gui = "bold" } },
  replace = { a = { fg = colors.bg0, bg = colors.sapphire, gui = "bold" } },
  insert = { a = { fg = colors.bg0, bg = colors.peach, gui = "bold" } },
  command = { a = { fg = colors.bg0, bg = colors.sky, gui = "bold" } },
  terminal = { a = { fg = colors.bg0, bg = colors.mauve, gui = "bold" } },
}
-- LSP clients attached to buffer
local function clients_lsp()
  -- local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return "󰌘  No servers"
  end

  local buf_client_names = {}
  for _, client in pairs(clients) do
    local client_name = client.name:gsub("%_", ""):gsub("(ls)", function(match)
      return match:upper()
    end)
    table.insert(buf_client_names, client_name)
  end

  local hash = {}
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, "  ")
  return "󰌘  " .. language_servers
end
-- color for lualine progress
vim.api.nvim_set_hl(0, "progressHl1", { fg = colors.red })
vim.api.nvim_set_hl(0, "progressHl2", { fg = colors.orange })
vim.api.nvim_set_hl(0, "progressHl3", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "progressHl4", { fg = colors.green })
vim.api.nvim_set_hl(0, "progressHl5", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "progressHl6", { fg = colors.blue })
vim.api.nvim_set_hl(0, "progressHl7", { fg = colors.purple })
require("multicursors").setup({
  hint_config = false,
})

local ok, devicons = pcall(require, "nvim-web-devicons")
require("lualine").setup({
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = customOneDark,
    disabled_filetypes = { tabline = { "NvimTree" } },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      {
        "mode",
        icon_enable = true,
        fmt = function()
          return mode.isNormal() and (ok and devicons.get_icon(vim.fn.expand("%:t")) or "")
            or mode.isInsert() and ""
            or mode.isVisual() and "󰈈"
            or mode.isCommand() and ""
            or mode.isReplace() and ""
            or vim.api.nvim_get_mode().mode == "t" and ""
            or ""
        end,
      },
    },
    lualine_b = {
      {
        "buffers",
        max_length = vim.o.columns * 8 / 10, -- Maximum width of buffers component,
        filetype_names = {
          minifiles = "Files",
        },
      },
    },
    lualine_c = {
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
        color = { fg = colors.peach },
      },
      {
        require("noice").api.status.command.get,
        cond = require("noice").api.status.command.has,
        color = { fg = colors.lavender },
      },
    },
    lualine_x = {
      "diagnostics",
      "diff",
    },
    lualine_y = {
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
    lualine_z = {
      clients_lsp,
    },
  },
  inactive_sections = {
    lualine_a = {
      { "filetype", colored = true, icon_only = true, icon = { align = "right" } },
      "filename",
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {
        function()
          return vim.api.nvim_get_current_win() .. ":" .. vim.api.nvim_get_current_buf()
        end,
      },
    },
    lualine_z = { "location" },
  },
})

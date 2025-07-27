return {
  "rasulomaroff/reactive.nvim",
  event = "VeryLazy",
  config = function()
    local c = require("config.colorscheme")
    require("reactive").add_preset({
      name = "cusorline",
      static = {
        winhl = {
          inactive = {
            CursorLine = { bg = "NONE" },
            CursorLineNr = { bg = "NONE", fg = c.base01 },
            CursorLineSign = { bg = "NONE" },
            CursorLineFold = { bg = "NONE" },
          },
        },
      },
      modes = {
        n = {
          winhl = {
            CursorLine = { bg = c.base01 },
            CursorLineNr = { bg = c.base01, fg = c.base06, italic = true, bold = true },
            CursorLineSign = { bg = c.base01 },
            CursorLineFold = { bg = c.base01 },
          },
        },
        no = {
          operators = {
            [{ "gu", "gU", "g~", "~" }] = {
              winhl = {
                CursorLine = { bg = c.base10 },
                CursorLineNr = { bg = c.base10, fg = c.base06, italic = true, bold = true },
                CursorLineSign = { bg = c.base10 },
                CursorLineFold = { bg = c.base10 },
              },
            },
            -- delete operator
            d = {
              winhl = {
                CursorLine = { bg = c.base08 },
                CursorLineNr = { bg = c.base08, fg = c.base06, italic = true, bold = true },
                CursorLineSign = { bg = c.base08 },
                CursorLineFold = { bg = c.base08 },
              },
            },
            -- yank operator
            y = {
              winhl = {
                CursorLine = { bg = c.base11, fg = c.base06 },
                CursorLineNr = { bg = c.base11, fg = c.base03, italic = true, bold = true },
                CursorLineSign = { bg = c.base11 },
                CursorLineFold = { bg = c.base11 },
              },
            },
            -- change operator
            c = {
              winhl = {
                CursorLine = { bg = c.base0B },
                CursorLineNr = { bg = c.base0B, fg = c.base03, italic = true, bold = true },
                CursorLineSign = { bg = c.base0B },
                CursorLineFold = { bg = c.base0B },
              },
            },
          },
        },
        -- visual
        [{ "v", "V", "\x16" }] = {
          winhl = {
            Visual = { bg = c.base15, fg = c.base01 },
            CursorLineNr = { bg = c.base15, fg = c.base01, italic = true, bold = true },
            CursorLineSign = { bg = c.base15 },
            CursorLineFold = { bg = c.base15 },
          },
        },
        [{ "s", "S", "\x13" }] = {
          winhl = {
            Visual = { bg = c.base06 },
            CursorLineNr = { bg = c.base06, fg = c.base01, italic = true, bold = true },
            CursorLineSign = { bg = c.base06 },
            CursorLineFold = { bg = c.base06 },
          },
        },
        R = {
          winhl = {
            CursorLine = { bg = c.base09 },
            CursorLineNr = { bg = c.base09, fg = c.base01, italic = true, bold = true },
            CursorLineSign = { bg = c.base09 },
            CursorLineFold = { bg = c.base09 },
          },
        },
        i = {
          winhl = {
            CursorLine = { bg = c.base11 },
            CursorLineNr = { bg = c.base11, fg = c.base05, italic = true, bold = true },
            CursorLineSign = { bg = c.base11 },
            CursorLineFold = { bg = c.base11 },
          },
        },
      },
    })
  end,
}

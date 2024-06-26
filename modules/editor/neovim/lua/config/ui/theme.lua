local mode = require("config.helpers")

require("onedark").setup({
  style = "deep",
  transparent = true,
  ending_tildes = true,
  toggle_style_key = "<leader>tt",
  toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
  code_style = {
    comments = "italic",
    keywords = "none",
    functions = "italic",
    strings = "none",
    variables = "bold",
  },
  colors = require("config.colors"),
  highlights = {
    ["@lsp.type.variable"] = { fg = "$fg", fmt = "bold" },
    ["@variable"] = { fg = "$fg", fmt = "bold" },
    ["@variable.other"] = { fg = "$fg", fmt = "bold" },
    ["@variable.parameter"] = { fg = "$fg", fmt = "bold" },
    ["@string.quoted.astro"] = { fg = "$fg" },
    ["@meta.jsx.children.tsx"] = { fg = "$fg" },
    ["@string.quoted.double.tsx"] = { fg = "$fg" },
    ["@string.template"] = { fg = "$fg" },

    -- ["@entity.other.attribute-name"] = { fg = "$yellow", fmt = "italic" },
    -- ["@entity.other.attribute-name.tsx"] = { fg = "$yellow", fmt = "italic" },
    -- ["@entity.other.attribute-name.class.css"] = { fg = "$yellow", fmt = "italic" },
    -- ["@entity.name.type.class"] = { fg = "$yellow", fmt = "italic" },
    -- ["@meta.function"] = { fg = "$yellow", fmt = "italic" },
    -- ["@meta.function-call"] = { fg = "$yellow", fmt = "italic" },

    ["@support.class.component.tsx"] = { fg = "$cyan", fmt = "italic" },
    ["@support.class.component.astro"] = { fg = "$cyan", fmt = "italic" },
    ["@punctuation.definition.tag"] = { fg = "$cyan", fmt = "italic" },

    ["@punctuation.definition.template-expression.begin"] = { fmt = "italic" },
    ["@punctuation.definition.template-expression.end"] = { fmt = "italic" },
    ["@punctuation.section.embedded"] = { fmt = "italic" },
    ["@meta.decorator "] = { fmt = "italic" },
    ["@punctuation.decorator"] = { fmt = "italic" },

    -- ["@punctuation.definition.comment"] = { fg = "$dark_red", fmt = "italic" },
    -- ["@comment"] = { fg = "$dark_red", fmt = "italic" },

    ["@entity.name.tag"] = { fg = "$grey", fmt = "italic" },
    ["@support.type.property-name"] = { fg = "$grey", fmt = "italic" },

    ["@keyword"] = { fmt = "italic" },
    ["@constant"] = { fmt = "italic" },
    ["@storage.modifier"] = { fmt = "italic" },
    ["@storage.type"] = { fmt = "italic" },
    ["@storage.type.class.js"] = { fmt = "italic" },

    ["@entity.name.function"] = { fg = "$blue", fmt = "bold" },
    ["@entity.name.type.alias"] = { fg = "$red", fmt = "bold" },

    ["@keyword.control"] = { fmt = "italic" },

    MatchParen = { fg = "$none", bg = "$matchParen" },
  },
})
require("onedark").load()

local colors = require("onedark.colors")

vim.o.guicursor = "n-o:block-nCursor,i:ver20-iCursor,v-ve:block-vCursor,c-ci-cr:ver25-cCursor,r:hor15-rCursor"

-- cursor color
vim.api.nvim_set_hl(0, "nCursor", { bg = colors.lavender, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "iCursor", { bg = colors.peace, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "vCursor", { bg = colors.rosewater, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "cCursor", { bg = colors.sky, fg = colors.bg0 })
vim.api.nvim_set_hl(0, "rCursor", { bg = colors.sapphire, fg = colors.bg0 })

-- color for split
vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.blue })

-- cursor line color
vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.midnight })

-- line number color
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.lavender })

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    if mode.isNormal() then
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.lavender })
    elseif mode.isInsert() then
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.peach })
    elseif mode.isVisual() then
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.rosewater })
    elseif mode.isReplace() then
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.sapphire })
    end
    -- command mode doesn't have line number
  end,
})

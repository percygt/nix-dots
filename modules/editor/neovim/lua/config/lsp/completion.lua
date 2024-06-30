local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require("lspkind")
local cmp_under_comparator = require("cmp-under-comparator")
local extends = {
  ["typescript"] = { "tsdoc" },
  ["javascript"] = { "jsdoc" },
  ["lua"] = { "luadoc" },
  ["python"] = { "pydoc" },
  ["rust"] = { "rustdoc" },
  ["cs"] = { "csharpdoc" },
  ["java"] = { "javadoc" },
  ["c"] = { "cdoc" },
  ["cpp"] = { "cppdoc" },
  ["sh"] = { "shelldoc" },
}

luasnip.setup({
  history = true,
  region_check_events = "CursorMoved",
  delete_check_events = "TextChanged",
})
require("luasnip.loaders.from_vscode").lazy_load()

for k, v in ipairs(extends) do
  luasnip.filetype_extend(k, v)
end
local icons = {
  Namespace = "󰌗",
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰆧",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈚",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
  Table = "",
  Object = "󰅩",
  Tag = "",
  Array = "[]",
  Boolean = "",
  Number = "",
  Null = "󰟢",
  String = "󰉿",
  Calendar = "",
  Watch = "󰥔",
  Package = "",
  Copilot = "",
  Codeium = "",
  TabNine = "",
}
local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
cmp.setup({
  preselect = cmp.PreselectMode.None,
  window = {
    completion = cmp.config.window.bordered({
      border = border,
      winhighlight = "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
      scrollbar = false,
      sidePadding = 0,
    }),
    documentation = cmp.config.window.bordered({
      documentation = {
        winhighlight = "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
        border = border,
      },
    }),
  },
  completion = {
    completeopt = "menu,menuone,preview,noselect",
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      require("clangd_extensions.cmp_scores"),
      cmp.config.compare.score,
      cmp_under_comparator.under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ["<c-c>"] = cmp.mapping.abort(),
    ["<c-space>"] = cmp.mapping.complete(),
    ["<cr>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "i", "c" }
    ),
    ["<tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<s-tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "async_path", priority_weight = 110 },
    { name = "nvim_lsp", priority_weight = 100 },
    { name = "nvim_lua", priority_weight = 90 },
    { name = "luasnip", priority_weight = 80 },
    { name = "buffer", max_item_count = 5, priority_weight = 50 },
    { name = "codeium", priority_weight = 70 },
    { name = "conjure" },
  },
  -- Pictograms
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
      symbol_map = icons,
    }),
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline({
    ["<esc>"] = {
      c = cmp.mapping.confirm({ select = false }),
    },
  }),
  sources = {
    { name = "buffer" },
  },
})
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "async_path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })
-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})
-- -- Autopairs
-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- require("nvim-autopairs").setup({ check_ts = true })
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))

local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require("lspkind")
luasnip.setup({
	region_check_events = "CursorMoved",
})
-- Friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	preselect = cmp.PreselectMode.None,
	completion = {
		completeopt = "menu,menuone,preview,noselect",
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<c-u>"] = cmp.mapping.scroll_docs(-4),
		["<c-d>"] = cmp.mapping.scroll_docs(4),
		["<c-e>"] = cmp.mapping.abort(),
		["<c-space>"] = cmp.mapping.complete(),
		["<cr>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
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
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	-- Pictograms
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
})

-- Autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("nvim-autopairs").setup({ check_ts = true })
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))

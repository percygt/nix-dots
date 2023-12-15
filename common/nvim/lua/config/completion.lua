vim.o.completeopt = "menuone,noselect,preview"

-- nvim-cmp setup
local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
		["<Right>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
			if cmp.visible() then
				local entry = cmp.get_selected_entry()
				if not entry then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				else
					cmp.confirm()
				end
			else
				fallback()
			end
		end, { "i", "s", "c" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
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
		format = function(_, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
			return vim_item
		end,
	},
})

-- Autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("nvim-autopairs").setup({ check_ts = true })
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))

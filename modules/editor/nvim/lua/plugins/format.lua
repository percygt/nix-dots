return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	keys = {
		{ "<a-f>", "<cmd>lua require('conform').format()<cr>", desc = "Format", silent = true },
	},
	opts = function()
		local prettier = { "prettierd", "prettier" }
		return {
			formatters = {
				-- nix = { "alejandra" },
				nix = { "nixfmt" },
				javascript = { "deno_fmt" },
				typescript = { "deno_fmt" },
				javascriptreact = { "deno_fmt" },
				typescriptreact = { "deno_fmt" },
				json = { "deno_fmt" },
				jsonc = { "deno_fmt" },
				markdown = { "deno_fmt" },
				astro = { prettier },
				vue = { prettier },
				css = { prettier },
				scss = { prettier },
				less = { prettier },
				html = { prettier },
				yaml = { prettier },
				mdx = { prettier },
				graphql = { prettier },
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				sh = { "shfmt" },
				-- python = { "ruff_format", "ruff_fix" },
				["_"] = { "trim_whitespace", "trim_newlines" },
			},
		}
	end,
	config = function(_, opts)
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = opts.formatters,
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 5000, lsp_fallback = true }
			end,
		})
		conform.formatters.injected = {
			lang_to_formatters = opts.formatters,
			options = {
				ignore_errors = false,
				lang_to_ext = {
					nix = "nix",
					lua = "lua",
					bash = "sh",
					javascript = "js",
					latex = "tex",
					markdown = "md",
					python = "py",
					rust = "rs",
					r = "r",
					typescript = "ts",
				},
			},
		}
	end,
}

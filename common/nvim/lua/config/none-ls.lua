local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	debug = true,
	sources = {
		-- Python
		formatting.black,
		formatting.isort,
		diagnostics.pylama,

		diagnostics.eslint_d,

		formatting.prettierd.with({
			filetypes = {
				"css",
				"scss",
				"less",
				"html",
				"json",
				"yaml",
				"markdown",
				"graphql",
			},
		}),

		-- Shell
		formatting.shfmt,
		formatting.shellharden,
		diagnostics.shellcheck,
		code_actions.shellcheck,

		-- JS yaml html markdown

		diagnostics.yamllint,
		diagnostics.markdownlint,

		-- C/C++
		diagnostics.cppcheck,

		-- Go
		diagnostics.golangci_lint,

		-- Lua
		diagnostics.selene,

		-- Spelling
		-- completion.spell,
		diagnostics.codespell.with({
			args = { "--builtin", "clear,rare,code", "-" },
		}),

		-- Nix
		diagnostics.statix,
		code_actions.statix,
		formatting.nixpkgs_fmt,

		-- Git
		code_actions.gitsigns,
		diagnostics.gitlint,

		diagnostics.actionlint,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})

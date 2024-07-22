return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	keys = {
		{
			"<a-f>",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format",
			silent = true,
		},
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
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			-- Set default options
			default_format_opts = { lsp_format = "fallback" },
			formatters = {
				injected = { -- Set the options field
					options = {
						-- Set individual option values
						ignore_errors = true,
						lang_to_formatters = opts.formatters,
						lang_to_ext = {
							bash = "sh",
							lua = "lua",
							c_sharp = "cs",
							elixir = "exs",
							javascript = "js",
							julia = "jl",
							latex = "tex",
							markdown = "md",
							python = "py",
							ruby = "rb",
							rust = "rs",
							typescript = "ts",
						},
					},
				},
			},
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
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true })
	end,
}

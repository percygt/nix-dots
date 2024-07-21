return {
	jsonls = {
		settings = {
			json = {
				schema = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	terraformls = {
		cmd = { "terraform-ls" },
		arg = { "server" },
		filetypes = { "terraform", "tf", "terraform-vars" },
	},
	pylsp = {
		plugins = {
			ruff = {
				enabled = true,
				extendSelect = { "I" },
			},
			-- pylsp_mypy = {
			-- 	enabled = true,
			-- 	report_progress = true,
			-- 	live_mode = false,
			-- },
			jedi_completion = { fuzzy = true },
			black = { enabled = false },
			pyls_isort = { enabled = false },
			pylint = { enabled = false },
		},
	},
	clojure_lsp = {},
	clangd = {},
	nil_ls = {},
	nixd = {
		on_init = function(client, _)
			client.server_capabilities.semanticTokensProvider = nil
		end,
	},
	dockerls = {},
	bashls = {
		filetypes = { "sh", "zsh" },
	},
	vimls = {
		filetypes = { "vim" },
	},
	denols = {
		root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
	},
	tsserver = {
		documentFormatting = false,
		single_file_support = false,
		hostInfo = "neovim",
		root_dir = require("lspconfig").util.root_pattern("package.json"),
	},
	astro = {},
	solidity_ls_nomicfoundation = {},
	yamlls = {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml" },
	},
	zls = {},
	gopls = {
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
				},
			},
		},
	},

	marksman = {},
	taplo = {},
	cssls = {},
	lua_ls = {
		init_options = {
			documentFormatting = false,
		},
		settings = {
			Lua = {
				format = {
					enable = false,
					defaultConfig = {
						indent_style = "space",
						indent_size = "2",
						quote_style = "AutoPreferDouble",
						call_parentheses = "Always",
						column_width = "120",
						line_endings = "Unix",
					},
				},
				diagnostics = {
					enable = true,
					globals = { "vim", "hs" },
				},
				workspace = {
					library = {
						checkThirdParty = false,
					},
				},
				codeLens = {
					enable = true,
				},
				completion = {
					callSnippet = "Replace",
				},
				doc = {
					privateName = { "^_" },
				},
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
}

local M = {}
local lspconfig = require("lspconfig")
-- local lsp_signature = require("lsp_signature")
local navic = require("nvim-navic")
local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- common_capabilities.semanticTokensProvider = nil

function M.common_on_attach(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>ca", "<cmd>CodeActionMenu<CR>", opts)
	buf_set_keymap("v", "<leader>ca", "<cmd>CodeActionMenu<CR>", opts)
	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	buf_set_keymap("n", "<leader>o", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
	buf_set_keymap("n", "<leader>ff", " vim.lsp.buf.format<CR>", opts)

	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({async=true})' ]])

	lsp_signature.on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		floating_window_above_cur_line = true,
		handler_opts = {
			border = "rounded",
		},
	}, bufnr)

	-- if client.server_capabilities.documentSymbolProvider then
	-- 	navic.attach(client, bufnr)
	-- end

	-- client.server_capabilities.semanticTokensProvider = nil

	-- Disable tsserver formatting, as it conflicts with prettier
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end
end

function M.setup_servers(json_config)
	local f = io.open(json_config, "r")
	if not f then
		return
	end
	local lsp_servers = vim.json.decode(f:read("all*"))
	f:close()
	if lsp_servers == nil then
		return
	end
	for server, config in pairs(lsp_servers) do
		if server == "lua_ls" then
			config.settings.Lua.workspace.library = vim.api.nvim_get_runtime_file("", true)
		end
		if server == "denols" then
			config.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
		end
		if server == "tsserver" then
			config.root_dir = lspconfig.util.root_pattern("package.json")
			config.single_file_support = false
		end
		config.on_attach = M.common_on_attach
		config.capabilities = common_capabilities
		config.capabilities.offsetEncoding = { "utf-16" }
		lspconfig[server].setup(config)
	end
end

return M

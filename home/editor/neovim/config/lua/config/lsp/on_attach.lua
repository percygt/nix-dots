local telescope = require("telescope.builtin")
return function(client, bufnr)
  require("clangd_extensions.inlay_hints").setup_autocmd()
  require("clangd_extensions.inlay_hints").set_inlay_hints()
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")

  nmap("[d", vim.diagnostic.goto_prev, "Diagnostics: Go to Previous")
  nmap("]d", vim.diagnostic.goto_next, "Diagnostics: Go to Next")

  if client.supports_method("textDocument/documentSymbol") then
    nmap("gs", telescope.lsp_document_symbols, "Document symbols")
  end
  if client.supports_method("textDocument/declaration") then
    nmap("gD", vim.lsp.buf.declaration, "Declaration")
  end

  if client.supports_method("textDocument/typeDefinition") then
    nmap("gt", vim.lsp.buf.type_definition, "Type definition")
  end

  if client.supports_method("textDocument/definition") then
    nmap("gd", vim.lsp.buf.definition, "Definition")
  end

  if client.supports_method("textDocument/references") then
    nmap("gr", telescope.lsp_references, "References")
  end

  if client.supports_method("textDocument/implementation") then
    nmap("gi", vim.lsp.buf.implementation, "Implementation")
  end

  if client.supports_method("workspace/symbol") then
    nmap("gw", telescope.lsp_workspace_symbols, "Workspace symbols")
  end

  if client.supports_method("textDocument/codeAction") then
    nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  end
  if client.supports_method("textDocument/rename") then
    nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  end

  if client.name == "ruff-lsp" then
    client.server_capabilities.hoverProvider = false
  end
end

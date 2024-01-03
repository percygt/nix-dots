local M = {}
local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
function M.setup_null_ls(json_config)
  local f = io.open(json_config, "r")
  if not f then
    return
  end
  local langToolsConfig = vim.json.decode(f:read "all*")
  f:close()
  if langToolsConfig.null_ls == nil then
    return
  end
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions

  function config_check(config)
    local config_tbl = {}
    if config.filetypes and next(config.filetypes) then
      config_tbl.filetypes = config.filetypes
    end
    if config.args and next(config.args) then
      config_tbl.args = config.args
    end
    if config.extra_args and next(config.extra_args) then
      config_tbl.extra_args = config.extra_args
    end
    if config.disabled_filetypes and next(config.disabled_filetypes) then
      config_tbl.disabled_filetypes = config.disabled_filetypes
    end
    if config.extra_filetypes and next(config.extra_filetypes) then
      config_tbl.extra_filetypes = config.extra_filetypes
    end
    if config.condition and next(config.condition) and config.condition.root_has_file then
      config_tbl.condition = function(utils)
        return utils.root_has_file(config.condition.root_has_file)
      end
    end
    return config_tbl
  end
  local source_tbl = {}
  for fmt, config in pairs(langToolsConfig.null_ls.formatting) do
    if not next(config) then
      table.insert(source_tbl, formatting[fmt])
    else
      table.insert(source_tbl, formatting[fmt].with(config_check(config)))
    end
  end
  for diag, config in pairs(langToolsConfig.null_ls.diagnostics) do
    if not next(config) then
      table.insert(source_tbl, diagnostics[diag])
    else
      table.insert(source_tbl, diagnostics[diag].with(config_check(config)))
    end
  end
  for ca, config in pairs(langToolsConfig.null_ls.code_actions) do
    if not next(config) then
      table.insert(source_tbl, code_actions[ca])
    else
      table.insert(source_tbl, code_actions[ca].with(config_check(config)))
    end
  end
  null_ls.setup {
    sources = source_tbl,
    on_attach = function(client, bufnr)
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds {
          group = augroup,
          buffer = bufnr,
        }

        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format {
              filter = function()
                return client.name == "null-ls"
              end,
              bufnr = bufnr,
            }
          end,
        })
      end
    end,
  }
end

return M

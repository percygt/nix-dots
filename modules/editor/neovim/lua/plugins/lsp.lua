return {
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        suppress_on_insert = false, -- Suppress new messages while in insert mode
        ignore_done_already = false, -- Ignore new tasks that are already complete
        display = {
          render_limit = 5, -- How many LSP messages to show at once
          done_ttl = 2, -- How long a message should persist after completion
          done_icon = require("config.icons").ui.Accepted, -- Icon shown when all LSP progress tasks are complete
        },
      },
      notification = {
        override_vim_notify = false, -- Automatically override vim.notify() with Fidget
        window = {
          winblend = 0, -- Background color opacity in the notification window
          zindex = 75, -- Stacking priority of the notification window
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "folke/neoconf.nvim",
      { "b0o/schemastore.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "p00f/clangd_extensions.nvim" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local completion = require("cmp_nvim_lsp").default_capabilities(capabilities)
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
      capabilities.textDocument.completion = completion.textDocument.completion
      require("neoconf").setup({})
      require("lspconfig.ui.windows").default_options.border = "single"
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      local lsp_servers = require("config.lsp-servers")
      require("mason-lspconfig").setup({
        automatic_installation = false,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              -- on_attach = require("plugins.lsp.on_attach").on_attach,
              settings = lsp_servers[server_name],
              filetypes = (lsp_servers[server_name] or {}).filetypes,
            })
          end,
        },
      })

      local lspconfig = require("lspconfig")

      for server, config in pairs(lsp_servers) do
        if config.root_pattern and next(config.root_pattern) then
          config.root_dir = lspconfig.util.root_pattern(unpack(config.root_pattern))
          config.root_pattern = nil
        end
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      local clangd_inlay = require("clangd_extensions.inlay_hints")
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          clangd_inlay.setup_autocmd()
          clangd_inlay.set_inlay_hints()
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end
          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
          map("gr", require("telescope.builtin").lsp_references, "Goto References")
          map("gi", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          map("go", require("telescope.builtin").lsp_type_definitions, "Type Definition")
          map("gs", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          map("gw", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")

          map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gS", vim.lsp.buf.signature_help, "Signature Documentation")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")

          map("<leader>c", "", "Code")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>cd", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("nvim-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("nvim-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "nvim-lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })
    end,
  },
}

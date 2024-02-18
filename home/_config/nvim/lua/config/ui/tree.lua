local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      api.node.open.edit()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end

  -- open as vsplit on current node
  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file as vsplit
      api.node.open.vertical()
    end

    -- Finally refocus on tree if it was lost
    api.tree.focus()
  end
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
  vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
  vim.keymap.set("n", "h", api.tree.close, opts("Close"))
  vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

vim.keymap.set("n", "<leader>et", "<cmd>NvimTreeToggle<cr>")

require("nvim-tree").setup({
  on_attach = on_attach,
  sync_root_with_cwd = true,
  view = {
    width = 35,
    relativenumber = false,
  },
  -- change folder arrow icons
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      web_devicons = {
        folder = {
          enable = true,
        },
      },
    },
  },

  -- disable window_picker for
  -- explorer to work well with
  -- window splits
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
  filters = {
    custom = { ".DS_Store", "^.git$" },
  },
  git = {
    ignore = false,
  },
})

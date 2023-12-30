local harpoon = require("harpoon")
local setKey = vim.keymap.set
-- REQUIRED
harpoon:setup()
-- REQUIRED

setKey("n", "<leader>a", function()
  harpoon:list():append()
end)
setKey("n", "<a-1>", function()
  harpoon:list():select(1)
end)
setKey("n", "<a-2>", function()
  harpoon:list():select(2)
end)
setKey("n", "<a-3>", function()
  harpoon:list():select(3)
end)
setKey("n", "<a-4>", function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
setKey("n", "<a-h>", function()
  harpoon:list():prev()
end)
setKey("n", "<a-l>", function()
  harpoon:list():next()
end)
setKey("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
-- basic telescope configuration
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require("telescope.pickers")
--       .new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--           results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--       })
--       :find()
-- end
--
-- setKey("n", "<c-e>", function()
--   toggle_telescope(harpoon:list())
-- end, { desc = "Open harpoon window" })

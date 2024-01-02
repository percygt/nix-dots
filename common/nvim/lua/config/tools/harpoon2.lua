local harpoon = require("harpoon")
local setKey = vim.keymap.set
-- REQUIRED
harpoon:setup()
-- REQUIRED

setKey("n", "<a-m>", function()
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
setKey("n", "<a-.>", function()
  harpoon:list():prev()
end)
setKey("n", "<a-,>", function()
  harpoon:list():next()
end)
setKey("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

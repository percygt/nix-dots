return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
  -- stylua: ignore
	keys = {
    { "<leader>m", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon" },
		{ "<a-m>", function() require("harpoon"):list():add() end, desc = "Harpoon mark" },
		{ "<a-1>", function() require("harpoon"):list():select(1) end, desc = "Harpoon select 1" },
		{ "<a-2>", function() require("harpoon"):list():select(2) end, desc = "Harpoon select 2" },
		{ "<a-3>", function() require("harpoon"):list():select(3) end, desc = "Harpoon select 3" },
		{ "<a-4>", function() require("harpoon"):list():select(4) end, desc = "Harpoon select 4" },
		{ "<a-h>", function() require("harpoon"):list():prev() end, desc = "Harpoon previous" },
		{ "<a-l>", function() require("harpoon"):list():next() end, desc = "Harpoon next" },
	},
	config = function()
		require("harpoon"):setup()
	end,
}

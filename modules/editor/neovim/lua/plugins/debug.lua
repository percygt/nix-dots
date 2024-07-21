---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end
return {
	{
		"mfussenegger/nvim-dap",
		event = "BufRead",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
			{ "mfussenegger/nvim-dap-go", opts = {} },
			"mfussenegger/nvim-dap-python",
			"nvim-neotest/nvim-nio",
		},
    -- stylua: ignore
		keys = {
			{ "<leader>D", "", desc = "+Debug", mode = { "n", "v" } },
		  { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>Dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>Da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>DC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>Dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>Di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>Dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>Dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>Dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>Do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>DO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>Dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>Ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>Dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>Dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
		config = function()
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(require("config.icons").dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>Du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>De", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	-- mason.nvim integration
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = false,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
		},
		-- mason-nvim-dap is loaded when nvim-dap loads
		config = function() end,
	},
}

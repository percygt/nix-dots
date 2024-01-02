require("dapui").setup()
require("dap-go").setup()
require("dap-python").setup()
require("nvim-dap-virtual-text").setup()

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		astro = { "prettier" },
	},
	format_on_save = function(bufnr)
		-- Disable autoformat for files in a certain path
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end

		return { timeout_ms = 500, lsp_fallback = true, async = true }
	end,
	-- format_after_save = { lsp_fallback = true },
})

conform.formatters.prettier.args = function(ctx)
	local args = { "--stdin-filepath", "$FILENAME" }
	-- local localPrettierConfig = vim.fs.find(".prettierrc.json", {
	-- 	upward = true,
	-- 	path = ctx.dirname,
	-- 	type = "file",
	-- })[1]
	-- local globalPrettierConfig = vim.fs.find(".prettierrc.json", {
	-- 	path = vim.fn.expand("~/.config/nvim"),
	-- 	type = "file",
	-- })[1]

	-- -- Project config takes precedence over global config
	-- if localPrettierConfig then
	-- 	vim.list_extend(args, { "--config", localPrettierConfig })
	-- elseif globalPrettierConfig then
	-- 	vim.list_extend(args, { "--config", globalPrettierConfig })
	-- end

	local isUsingAstro = vim.fs.find("astro.config.mjs", {
		upward = true,
		path = ctx.dirname,
		type = "file",
	})[1]
	if isUsingAstro then
		vim.notify(
			"Tailwind was detected for your project. You can really benefit from automatic class sorting. Please run npm i -D prettier-plugin-tailwindcss",
			vim.log.levels.WARN
		)
	end

	if localAstrocssPlugin then
		vim.list_extend(args, { "--plugin", localAstrocssPlugin })
	else
		if isUsingAstro then
			vim.notify(
				"Tailwind was detected for your project. You can really benefit from automatic class sorting. Please run npm i -D prettier-plugin-tailwindcss",
				vim.log.levels.WARN
			)
		end
	end

	return args
end

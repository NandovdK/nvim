return {
	{
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff" },
				terraform = { "terraform" },
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("ConformFormatAutogroup", {}),
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
					})
				end,
			})
		end,
	},
}

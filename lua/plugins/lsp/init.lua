local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(event)
			require("plugins.lsp.keymaps").on_attach(event)
		end,
	})

	require("mason").setup()

	local auto_install = {
		"ruff",
		"basedpyright",
		"stylua",
		"lua_ls",
	}

	require("mason-tool-installer").setup({
		ensure_installed = auto_install,
	})

	local servers = {
		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		},
		ruff = {},
		basedpyright = {},
		terraform_ls = {},
		terraform = {},
		tflint = {},
		stylua = {},
	}

	local capabilities = require("plugins.lsp.capabilities").get_capabilities()
	require("mason-lspconfig").setup({
		ensure_installed = auto_install,
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return M

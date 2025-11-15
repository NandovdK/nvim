local function get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend(
		"force",
		capabilities,
		require("cmp_nvim_lsp").default_capabilities()
	)
	return capabilities
end

local function setup_document_highlight(event, client)
	if client and client.server_capabilities.documentHighlightProvider then
		local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
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
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
			end,
		})
	end
end

local function on_attach(event)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	local telescope = require("telescope.builtin")

	map("gd", telescope.lsp_definitions, "[G]oto [D]efinition")
	map("gr", telescope.lsp_references, "[G]oto [R]eferences")
	map("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
	map("<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")
	map("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map("K", vim.lsp.buf.hover, "Hover Documentation")
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, "[T]oggle Inlay [H]ints")
	end

	setup_document_highlight(event, client)
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					on_attach(event)
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

			local capabilities = get_capabilities()
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
		end,
	},
}

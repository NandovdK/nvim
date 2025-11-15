return {
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		event = { "VimEnter */*,.*", "BufNew */*,.*" },

		keys = {
			{ "<leader>p", ":Oil<CR>", { desc = "Open Oil file explorer" } },
		},
		opts = {
			view_options = {
				show_hidden = true,
			},
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
		},
	},
}

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "<leader>p", ":Oil<CR>", { desc = "Open Oil file explorer" })

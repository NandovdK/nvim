require("catppuccin").setup({
	flavour = "auto", -- latte, frappe, macchiato, mocha
	background = {
		light = "latte",
		dark = "mocha",
	},
	transparency = true,
	show_end_of_buffer = false,
	term_colors = true,
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	styles = {
		comments = { "italic" },
		functions = { "bold" },
		keywords = { "italic" },
		strings = {},
		variables = {},
	},
	integrations = {
		cmp = true,
		gitsigns = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
		lsp_trouble = true,
		mason = true,
		nvimtree = true,
		telescope = true,
	},
})

vim.cmd.colorscheme("catppuccin")

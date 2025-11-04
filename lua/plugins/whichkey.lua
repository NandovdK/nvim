local whichkey = require("which-key")

whichkey.setup()
whichkey.add({
	{ "<leader>c", group = "[C]ode" },
	{ "<leader>d", group = "[D]ocument" },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>r", group = "[R]ename" },
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>t", group = "[T]oggle" },
	{ "<leader>w", group = "[W]orkspace" },
})

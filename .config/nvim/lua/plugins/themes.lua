return {
	-- add nord theme
	--{ "shaunsingh/nord.nvim" },
	{ "catppuccin/nvim" },
	--{"AlexvZyl/nordic.nvim"},

	-- Configure LazyVim to load nord
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}

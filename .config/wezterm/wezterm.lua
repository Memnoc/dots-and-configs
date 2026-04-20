local wezterm = require("wezterm")

return {
	color_scheme = "rose-pine-dawn",
	font = wezterm.font("JetBrains Mono"),
	font_size = 12.0,
	window_padding = { left = 12, right = 12, top = 14, bottom = 14 },
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	enable_scroll_bar = false,
	audible_bell = "Disabled",
}

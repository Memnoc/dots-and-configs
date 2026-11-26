local wezterm = require("wezterm")

local config = {
	color_scheme = "rose-pine",
	font = wezterm.font("JetBrainsMono Nerd Font"),
	-- Retina macOS needs a larger size than the Linux machines.
	font_size = wezterm.target_triple:find("darwin") and 18.0 or 12.0,
	window_padding = { left = 12, right = 12, top = 14, bottom = 14 },
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	enable_scroll_bar = false,
	audible_bell = "Disabled",
	visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 },
	hide_mouse_cursor_when_typing = true,

	-- Cursor matches Ghostty: Rose Pine iris, dark Rose Pine letter.
	default_cursor_style = "SteadyBlock",
	colors = {
		cursor_bg = "#c4a7e7",
		cursor_border = "#c4a7e7",
		cursor_fg = "#191724",
	},
}

-- Use the desktop/system SSH agent directly instead of WezTerm's proxy.
-- The option only exists after the 20240203 stable release (e.g. Homebrew's macOS cask).
if wezterm.version > "20240203-110809-5046fc22" then
	config.mux_enable_ssh_agent = false
end

return config

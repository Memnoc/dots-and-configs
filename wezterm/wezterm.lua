-- WezTerm config, kept in step with ../ghostty/config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Theme and font
config.color_scheme = "rose-pine"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12

-- Cursor: Uzume warm orange dimmed to ~82%, dark Rose Pine base for the letter
config.default_cursor_style = "SteadyBlock"
config.colors = {
  cursor_bg = "#ca8e60",
  cursor_border = "#ca8e60",
  cursor_fg = "#191724",
}

-- Window: no title bar, tabs only when there are several, no scrollbar
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = { left = 12, right = 12, top = 14, bottom = 14 }
config.window_background_opacity = 1.0

-- Silent bell, hide mouse while typing
config.audible_bell = "Disabled"
config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }
config.hide_mouse_cursor_when_typing = true

-- Use the desktop SSH agent (gcr) directly instead of WezTerm's proxy
config.mux_enable_ssh_agent = false

return config

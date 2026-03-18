local wezterm = require 'wezterm'
local config = wezterm.config_builder()

--- Technical setup
config.default_prog = { "/bin/zsh" }

--- Font config
config.font_size = 10
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.enable_wayland = false

--- Colors
config.colors = {
  cursor_bg = "white",
  cursor_border = "white"
}

-- Apperance
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

--- Misc settings
config.max_fps = 120
config.prefer_egl = true

return config

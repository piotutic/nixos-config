{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # General settings
    settings = {
      font_family      = "JetBrainsMono Nerd Font";
      font_size        = 13.0;
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";

      # Window
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      # Tabs
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      active_tab_font_style = "bold";

      # Colors (Tokyo Night theme, professional but modern)
      foreground = "#c0caf5";
      background = "#1a1b26";
      color0     = "#15161e";
      color1     = "#f7768e";
      color2     = "#9ece6a";
      color3     = "#e0af68";
      color4     = "#7aa2f7";
      color5     = "#bb9af7";
      color6     = "#7dcfff";
      color7     = "#a9b1d6";
      color8     = "#414868";
      color9     = "#f7768e";
      color10    = "#9ece6a";
      color11    = "#e0af68";
      color12    = "#7aa2f7";
      color13    = "#bb9af7";
      color14    = "#7dcfff";
      color15    = "#c0caf5";

      # Scrollback
      scrollback_lines = 10000;
    };

    # Keybindings
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left"  = "previous_tab";
      "ctrl+shift+enter" = "new_window";
    };
  };
}

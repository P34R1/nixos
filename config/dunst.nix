{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
  # https://mynixos.com/home-manager/options/services.dunst

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = mouse;
	width = 350;
        origin = bottom-right;
        offset = 48x48;

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 400;
        progress_bar_corner_radius = 5;

        indicate_hidden = yes;
        shrink = no;
		separator_height = 2;
        separator_color = "#11111b";
        padding = 15;
        horizontal_padding = 15;
        frame_width = 0;
        corner_radius = 10;
        sort = yes;
        idle_threshold = 120;

        font = Maple Mono 10;
        line_height = 0;
        markup = full;
        format = "<span weight='bold' font='12'>%s</span>\n%b";
        alignment = left;
        vertical_alignment = center;
        show_age_threshold = 60;
        word_wrap = yes;
        ellipsize = middle;
        ignore_newline = no;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = yes;
        icon_position = left;
        min_icon_size = 50;
        max_icon_size = 60;
        icon_path = $HOME/.local/share/icons/dunst;
        sticky_history = yes;
        history_length = 20;
        always_run_script = true;
        title = Dunst;
        class = Dunst;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = do_action, close_current;
        mouse_middle_click = do_action, close_current;
        mouse_right_click = close_all;
      };

      experimental.per_monitor_dpi = false

      urgency_low = {
        background = "#181825";
        foreground = "#CDD6F4";
        highlight = "#CDD6F4";
        frame_color = "#181825";
        timeout = 5;
      };

      urgency_normal = {
        background = "#181825";
        foreground = "#CDD6F4";
        highlight = "#CDD6F4";
        frame_color = "#181825";
        timeout = 5;
      };

      urgency_critical = {
        background = "#181825";
        foreground = "#CDD6F4";
        frame_color = "#f38ba8";
        timeout = 1000;
      };

      volume = {
        appname = "Volume";
        highlight = "#cba6f7";
      };

      backlight = {
        appname = "Backlight";
        highlight = "#eba0ac";
      };
      # vim: ft=cfg
    };
  };
}

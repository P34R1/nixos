{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    
    settings = {
      general = {
#        disable_loading_bar = true;
        grace = 0;
#        hide_cursor = true;
#        no_fade_in = true;
      };

      background = [
        {
          path = "$HOME/.local/share/wall.png";
          blur_size = 4;
          blur_passes = 3; # 0 disables blurring
          noise = 0.0117;
          contrast = 1.3000; # Vibrant!!!
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color = "rgb(11111b)";
          inner_color = "rgb(11111b)";
          font_color = "rgb(cdd6f4)";
          fade_on_empty = true;
          placeholder_text = "";
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color = "rgb(fab387)";
          fail_color = "rgb(f38ba8)"; # if authentication failed, changes outer_color and fail message color
          fail_text = "";
          fail_transition = 300; # transition time in ms between normal outer_color and fail_color
          position = "0, 75";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo $(date +\"%H:%M:%S\")";
          color = "rgb(cba6f7)";
          font_size = 64;
          font_family = "Maple Mono NF";
          position = "0, 16";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "cmd[update:1000] echo $(date +\"%A, %d %B %Y\")";
          color = "rgb(cdd6f4)";
          font_size = 24;
          font_family = "Maple Mono NF";
          position = "0, -30";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "";
          color = "rgb(cdd6f4)";
          font_size = 18;
          font_family = "Maple Mono NF";
          position = "0, 30";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}

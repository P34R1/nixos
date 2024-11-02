{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.hyprlock.enable
  programs.hyprlock = with config.colorScheme.palette; {
    enable = true;

    # https://github.com/ericmurphyxyz/dotfiles/blob/master/.config/hypr/hyprlock.conf
    # https://github.com/justinmdickey/publicdots/blob/main/.config/hypr/hyprlock.conf
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = true;
      };

      background = [
        {
          path = "$HOME/.local/share/wall.png";
          blur_size = 2;
          blur_passes = 1; # 0 disables blurring
          noise = 1.17e-2;
          contrast = 1.3; # Vibrant!!!
          brightness = 0.8;
          vibrancy = 0.21;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color = "rgb(${base01})";
          inner_color = "rgb(${base00})";
          font_color = "rgb(${base06})";
          fade_on_empty = true;
          placeholder_text = "";
          hide_input = false;
          rounding = 0; # -1 means complete rounding (circle/oval)
          check_color = "rgb(${base0A})";
          fail_color = "rgb(${base08})"; # if authentication failed, changes outer_color and fail message color
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
          text = "cmd[update:1000] echo $(date +\"%-I:%M:%S\")";
          color = "rgb(${base0C})";
          font_size = 95;
          font_family = "Jetbrains Mono Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}

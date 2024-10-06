{ config, pkgs, ... }:

{
  # Refer to https://wiki.hyprland.org/Configuring/Variables/
  wayland.windowManager.hyprland.settings = {

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = with config.colorScheme.palette; {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
      #col.inactive_border = rgba(595959aa)
      col.active_border = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
      col.inactive_border = "rgba(${base00}ff)";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      col.shadow = "rgba(1a1a1aee)";

      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        enabled = true;
        size = 3;
        passes = 1;

        vibrancy = 0.1696;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = true;

      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = "windows, 1, 7, myBezier";
      animation = "windowsOut, 1, 7, default, popin 80%";
      animation = "border, 1, 10, default";
      animation = "borderangle, 1, 8, default";
      animation = "fade, 1, 7, default";
      animation = "workspaces, 1, 6, default";
    };

     # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
     dwindle = {
       pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
       preserve_split = true # You probably want this
     };

     # https://wiki.hyprland.org/Configuring/Variables/#misc
     misc = {
       force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
       disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
     };
  };
}

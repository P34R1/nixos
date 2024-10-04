{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = with config.colorScheme.colors; {
        "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = "rgba(${base00}ff)";

        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
#        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
#        col.inactive_border = rgba(595959aa)

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };
  };
}

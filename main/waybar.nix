{ config, pkgs, ... }:

{
  programs.waybar.enable = true;
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = [ "hyprland/workspaces" "hyprland/mode" "wlr/taskbar" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "mpd" "clock" ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
      };

      "clock" = {
        format = "{:%a, %b %d | %I:%M}";
      };
    };
  };
}

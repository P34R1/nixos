{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = [ "hyprland/workspaces" "wlr/taskbar" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "mpd" "clock" ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{name}";
      };

      "clock" = {
        format = "{:%a, %b %d | %I:%M}";
      };
    };
  };  
}

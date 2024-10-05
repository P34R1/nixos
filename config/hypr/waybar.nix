{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
#      height = 30;

      modules-left = [ "hyprland/workspaces" "custom/arrow#right" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "custom/arrow#sound"
        "custom/spotify"
        "custom/arrow#memory"
        "memory"
        "custom/arrow#tray"
        "tray"
        "clock#date"
        "custom/arrow#time"
        "clock#time"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{name}";
        #format = " {icon} ";
        format-icons = {
          "1" = "1";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
        };
      };

      "custom/spotify" = {
        interval = 1;
        "return-type" = "json";
        exec = ./spotify.sh;
        exec-if = "pgrep spotify";
        escape = true;
      };

      memory = {
        interval = 5;
        format = "Mem {}%";
        states = {
          warning = 70;
          critical = 90;
        };
        tooltip = false;
      };

      tray = {
        icon-size = 18;
      };

      "custom/arrow#right" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow#time" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow#tray" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow#memory" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow#sound" = {
        format = "";
        tooltip = false;
      };

      "clock#time".tooltip = false;
      "clock#date".tooltip = false;

      "clock#time".format = "{:%I:%M}";
      "clock#date".format = "{:%a, %b %d}";
    };

    style = ./waybar.css;
  };  
}

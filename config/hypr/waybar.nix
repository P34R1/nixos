{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 20;

      modules-left = [ "hyprland/workspaces" "custom/arrow#right" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "custom/arrow#music"
        "custom/spotify"
        "custom/arrow#memory"
        "memory"
        "custom/arrow#date"
        "clock#date"
        "custom/arrow#time"
        "clock#time"
        "custom/arrow#tray"
        "tray"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        #format = "{name}";
        format = "{icon}";
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
        interval = 2;
        exec = ./spotify.sh;
        exec-if = "pgrep spotify";
        format = " {}";
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

      "custom/arrow#date" = {
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

      "custom/arrow#music" = {
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

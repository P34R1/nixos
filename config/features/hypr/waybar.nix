{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 20;

      modules-left = [
        "hyprland/workspaces"
        "custom/arrow#right"
        "hyprland/window"
      ];

      modules-right = [
        "custom/arrow#mpris"
        "mpris" # music info
        "custom/arrow#memory"
        "memory" # mem usage
        "custom/arrow#date"
        "clock#date" # date
        "custom/arrow#time"
        "clock#time" # time
        "custom/arrow#tray"
        "tray" # tray icons
      ];

      mpris = {
        format = "{title} {status_icon} {artist}";

        status-icons = {
          playing = "";
          paused = "";
          stopped = "";
        };

        # ignored-players = ["firefox" "librewolf"];

        on-scroll-up = "playerctld shift";
        on-scroll-down = "playerctld unshift";

        tooltip = false;
      };

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;

        # Leave empty for number
        format-icons = {
          "2" = "";
          "3" = "";
          #"4" = "";
          #"5" = "";
          #"6" = "";
        };
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

      # Time & Date
      "clock#time".format = "{:%I:%M}";
      "clock#date".format = "{:%a, %b %d}";

      "clock#time".tooltip = false;
      "clock#date".tooltip = false;

      # Arrows
      "custom/arrow#right".format = "";
      "custom/arrow#right".tooltip = false;

      "custom/arrow#tray".format = "";
      "custom/arrow#tray".tooltip = false;

      "custom/arrow#time".format = "";
      "custom/arrow#time".tooltip = false;

      "custom/arrow#date".format = "";
      "custom/arrow#date".tooltip = false;

      "custom/arrow#memory".format = "";
      "custom/arrow#memory".tooltip = false;

      "custom/arrow#mpris".format = "";
      "custom/arrow#mpris".tooltip = false;
    };

    style = ./waybar.css;
  };
}

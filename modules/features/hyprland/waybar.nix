{ self, inputs, ... }:

{
  flake.nixosModules.waybar =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.waybar = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.waybar = inputs.wrapper-modules.wrappers.waybar.wrap {
        inherit pkgs;
        settings = {
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
            "custom/arrow#battery"
            "battery#BAT0"
            "battery#BAT1"
            "custom/arrow#memory"
            "memory" # mem usage
            "custom/arrow#date"
            "clock#date"
            "custom/arrow#time"
            "clock#time"
            "custom/arrow#tray"
            "tray" # tray icons
          ];

          "battery#BAT0" = {
            format = "{capacity}%";
            tooltip = false;

            bat = "BAT0";
            interval = 5;
            states = {
              warning = 50;
              critical = 20;
            };
          };

          "battery#BAT1" = {
            format = " + {capacity}%";
            tooltip = false;

            bat = "BAT1";
            interval = 5;
            states = {
              warning = 50;
              critical = 20;
            };
          };

          mpris = {
            format = "{artist} {status_icon} {title}";
            tooltip = false;

            status-icons = {
              playing = "";
              paused = "│";
              stopped = "─";
            };

            # ignored-players = ["firefox" "librewolf"];

            on-scroll-up = "playerctld shift";
            on-scroll-down = "playerctld unshift";
          };

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";

            # Leave empty for number
            format-icons = {
              "2" = "";
              # "3" = "";
              #"4" = "";
              #"5" = "";
              #"6" = "";
            };
          };

          memory = {
            format = "Mem {}%";
            tooltip = false;
            interval = 5;
            states = {
              warning = 70;
              critical = 90;
            };
          };

          tray = {
            icon-size = 18;
          };

          # Time & Date
          "clock#time" = {
            format = "{:%I:%M}";
            tooltip = false;
          };

          "clock#date" = {
            format = "{:%a, %b %d}";
            tooltip = false;
          };

          # Arrows
          "custom/arrow#right" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow#tray" = {
            format = "";
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

          "custom/arrow#memory" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow#battery" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow#mpris" = {
            format = "";
            tooltip = false;
          };
        };

        "style.css".path = ./waybar.css;
      };
    };
}

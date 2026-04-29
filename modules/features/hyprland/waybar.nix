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
        settings =
          let
            mkArrow = format: {
              inherit format;
              tooltip = false;
            };

            mkBat = bat: {
              inherit bat;
              format = if (bat == "BAT0") then "{capacity}% " else "+ {capacity}%";
              tooltip = false;

              interval = 5;
              states = {
                warning = 50;
                critical = 20;
              };
            };
          in
          {
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

            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              format = "{icon}";

              # Leave empty for number
              format-icons = {
                "2" = "";
                "3" = "";
                "4" = "";
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

              on-scroll-up = "playerctld shift";
              on-scroll-down = "playerctld unshift";
            };

            "battery#BAT0" = mkBat "BAT0";
            "battery#BAT1" = mkBat "BAT1";

            memory = {
              format = "Mem {}%";
              tooltip = false;

              interval = 5;
              states = {
                warning = 70;
                critical = 90;
              };
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

            tray = {
              icon-size = 18;
              spacing = 10;
            };

            # Arrows
            "custom/arrow#right" = mkArrow "";
            "custom/arrow#tray" = mkArrow "";
            "custom/arrow#time" = mkArrow "";
            "custom/arrow#date" = mkArrow "";
            "custom/arrow#memory" = mkArrow "";
            "custom/arrow#battery" = mkArrow "";
            "custom/arrow#mpris" = mkArrow "";
          };

        "style.css".path = ./waybar.css;
      };
    };
}

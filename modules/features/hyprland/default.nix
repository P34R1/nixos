{ self, inputs, ... }:

{
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    {
      imports = with self.nixosModules; [
        hyprlock
        hypridle
        waybar
        dunst
        foot
        tofi
      ];

      loginScreen.window-managers = [
        {
          name = "hyprland";
          command = "start-hyprland";
          indicator = "h";
        }
      ];

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      environment.systemPackages = with pkgs; [
        awww
        wl-clipboard
        (writeShellScriptBin "screenshot" ''${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy'')
      ];

      programs.hyprland = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      };
    };

  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages.hyprland = self'.packages.hyprland-debug.wrap {
        debug = false;
      };

      packages.hyprland-debug = self.wrappers.hyprland.wrap (
        { config, ... }:
        let
          startup = pkgs.writeShellScriptBin "startup" ''
            dunst &
            wl-paste --type text --watch cliphist store &
            sleep 1
            ${lib.getExe self'.packages.waybar} & disown
            hypridle &
            awww-daemon & disown
          '';
        in
        {
          imports = with self.nixosModules; [
            hyprVisuals
            hyprWindowrules
          ];

          options.debug = lib.mkEnableOption "debug mode";
          config = {
            inherit pkgs;

            debug = lib.mkDefault true;
            settings = {
              monitor = [
                "eDP-1, preferred, auto, 1"
                "HDMI-A-4, preferred, auto, 1"
                ", preferred, auto, 1"
              ];

              cursor.no_hardware_cursors = true;
              exec-once = [
                "${lib.getExe startup}"
              ]
              ++ (lib.optionals (!config.debug) [
                "[workspace 1 silent] $TERMINAL"
                "[workspace 2 silent] zen"
                "[workspace 3 silent] steam"
                "[workspace 4 silent] discord"
              ]);

              "$mod" = if config.debug then "CAPSLOCK" else "SUPER";
              "$TERMINAL" = "foot";
              "$MENU" = "tofi-drun --drun-launch=true";
              "$LOCK" = "hyprlock";

              # bind  ->
              # bindm -> mouse
              # bindl -> do stuff even when locked
              # binde -> repeats when key is held
              bind = [
                "$mod, M, exit,"
                "$mod, C, killactive,"

                "$mod, G, togglegroup,"
                "$mod, V, togglefloating,"
                "$mod, B, fullscreen,"

                "$mod, RETURN, exec, $TERMINAL"
                "$mod, R, exec, $MENU"
                "$mod, L, exec, $LOCK"

                ", Print, exec, screenshot"
              ]
              ++ builtins.concatLists (
                builtins.genList (
                  i:
                  let
                    button = toString i;
                    workspace = if i == 0 then "10" else toString i;
                  in
                  [
                    "$mod, ${button}, workspace, ${workspace}"
                    "$mod SHIFT, ${button}, movetoworkspace, ${workspace}"
                    "$mod ALT, ${button}, changegroupactive, ${workspace}"
                  ]
                ) 10
              );

              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
              ];

              bindl = [
                ", XF86AudioPrev, exec, playerctl previous"
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"

                ", XF86AudioRaiseVolume, exec, volume up"
                ", XF86AudioLowerVolume, exec, volume down"
                ", XF86AudioMute,        exec, volume mute"

                ", XF86MonBrightnessUp,   exec, xbacklight -inc 5"
                ", XF86MonBrightnessDown, exec, xbacklight -dec 5"
              ];
            };

          };
        }
      );
    };
}

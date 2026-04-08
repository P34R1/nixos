{ self, inputs, ... }:

{
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    {
      imports = with self.nixosModules; [
        hyprLock
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

      packages.hyprland-debug = self.lib.wrappers.hyprland.config.wrap (
        { config, ... }:
        let
          startup =
            with self'.packages;
            pkgs.writeShellScriptBin "start" ''
              udiskie &
              ${lib.getExe dunst} &
              wl-paste --type text --watch cliphist store &
              sleep 1
              ${lib.getExe waybar} & disown
              # hypridle &
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
                "${startup}/bin/start"
              ]
              ++ (
                if config.debug then
                  [ "" ]
                else
                  [
                    "[workspace 1 silent] foot"
                    "[workspace 2 silent] zen"
                    "[workspace 3 silent] steam"
                    "[workspace 4 silent] discord"
                  ]
              );

              "$mod" = if config.debug then "ALT" else "SUPER";
              "$TERMINAL" = "foot";
              "$MENU" = "tofi-drun --drun-launch=true";

              # bind  ->
              # bindm -> mouse
              # bindl -> do stuff even when locked
              # binde -> repeats when key is held

              bind = [
                "$mod, RETURN, exec, $TERMINAL"
                "$mod, C, killactive,"
                "$mod, M, exit,"
                "$mod, V, togglefloating,"
                "$mod, B, fullscreen,"
                "$mod, R, exec, $MENU"

                # Example special workspace (scratchpad)
                "$mod, S, togglespecialworkspace, scratchpad"
                "$mod SHIFT, S, movetoworkspace, special:scratchpad"

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
                  ]
                ) 10
              );

              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
              ];

              bindl = [
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"
                ", XF86AudioRaiseVolume, exec, volume up"
                ", XF86AudioLowerVolume, exec, volume down"
                ", XF86AudioMute, exec, volume mute"
              ];
            };

          };
        }
      );
    };
}

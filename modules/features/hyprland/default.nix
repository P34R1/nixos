{ self, inputs, ... }:

{
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    let
      startup = pkgs.writeShellScriptBin "start" ''
        udiskie &
        dunst &
        wl-paste --type text --watch cliphist store &
        sleep 2
        waybar & disown
        hypridle &
        swww-daemon & disown
      '';
    in
    {
      imports = with self.nixosModules; [
        hyprGenerator
        waybar
        hyprVisuals
        hyprWindowrules
        hyprLock
        # hyprIdle
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
        swww
        wl-clipboard
      ];

      # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
      # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable

      hyprland.settings = {
        # My main moniter, max hz
        # monitor = "HDMI-A-4, 1920x1080@75, 0x0, 1";
        cursor.no_hardware_cursors = true;

        exec-once = [
          "${startup}/bin/start"

          "[workspace 1 silent] foot"
          # "[workspace 2 silent] librewolf"
          "[workspace 2 silent] zen"
          # "[workspace 4 silent] flatpak run dev.vencord.Vesktop"
          "[workspace 4] discord"
        ];

        "$mod" = "SUPER";
        "$TERMINAL" = "foot";
        "$MENU" = "tofi-drun --drun-launch=true";

        # Bind +
        # m -> mouse
        # l -> do stuff even when locked
        # e -> repeats when key is held

        bind = [
          "$mod, RETURN, exec, $TERMINAL"
          "$mod, C, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
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

      # systemd = {
      #   enable = true;
      #   variables = [ "--all" ];
      # };
    };
}

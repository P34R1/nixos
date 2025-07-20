{
  config,
  pkgs,
  lib,
  ...
}:

let
  startup = pkgs.writeShellScriptBin "start" ''
    ${pkgs.udiskie}/bin/udiskie &
    ${pkgs.dunst}/bin/dunst &
    ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store &
    sleep 2
    ${pkgs.waybar}/bin/waybar & disown
    ${pkgs.hypridle}/bin/hypridle &
    ${pkgs.swww}/bin/swww-daemon & disown
  '';
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland configuration";
  };

  config = lib.mkIf config.hyprland.enable {
    tofi.enable = true;
    dunst.enable = true;
    foot.enable = true;

    programs.hyprland.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = [ pkgs.swww ];

    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
    # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
    hm = {
      imports = [
        ./waybar.nix
        ./visuals.nix
        ./workspaces.nix
        ./windowrules.nix
        ./lock.nix
        ./idle.nix
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          # My main moniter, max hz
          monitor = "HDMI-A-4, 1920x1080@75, 0x0, 1";
          cursor.no_hardware_cursors = true;

          exec-once = [
            "${startup}/bin/start"

            "[workspace 1 silent] foot"
            "[workspace 2 silent] librewolf"
            # "[workspace 4 silent] flatpak run dev.vencord.Vesktop"
            "[workspace 4 silent] discord"
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
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          bindl = [
            ", XF86AudioPlay, exec, playerctl play-pause" # the stupid key is called play , but it toggles
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioRaiseVolume, exec, volume up"
            ", XF86AudioLowerVolume, exec, volume down"
            ", XF86AudioMute, exec, volume mute"
          ];
        };

        systemd = {
          enable = true;
          variables = [ "--all" ];
        };
      };
    };
  };
}

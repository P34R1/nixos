{ config, pkgs, lib, inputs, ... }:

let
  startup = pkgs.writeShellScriptBin "start" ''
    ${pkgs.udiskie}/bin/udiskie &
    ${pkgs.dunst}/bin/dunst &
    ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store &
    sleep 1
    ${pkgs.waybar}/bin/waybar & disown
    ${pkgs.hypridle}/bin/hypridle &
  '';


  # Determine which modules are enabled
  enabledOptions = lib.strings.concatStrings [
    (lib.strings.optionalString config.hyprland.enable "\\033[1m[h]\\033[0m - hyprland\\n")
    #(lib.strings.optionalString config.dwm.enable "\\033[1m[d]\\033[0m - dwm\\n")
  ];
in
{
  options = {
    hyprland.enable =
      lib.mkEnableOption "enables hyprland configuration";
  };

  config = lib.mkIf config.hyprland.enable {

    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
    # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
    home-manager.users.pearl = {
      imports = [
        ./waybar.nix
        ./visuals.nix
        ./workspaces.nix
        ./windowrules.nix
        ./lock.nix
        ./idle.nix
      ];

      # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
      home.file.".bash_profile".text = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          printf "${enabledOptions}"

          stty -icanon -echo
          choice=$(dd bs=1 count=1 2>/dev/null)
          stty icanon echo

          case "$choice" in
            h|H) exec hyprland;;
            d|D) exec dwm;;
          esac
        fi
      '';

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          # My main moniter, max hz
          monitor = "HDMI-A-4, highrr, 0x0, 1";
          cursor.no_hardware_cursors = true;

          exec-once = [
            "${startup}/bin/start"

            "[workspace 1 silent] foot"
            "[workspace 2 silent] librewolf"
            "[workspace 3 silent] spotify"
            "[workspace 4 silent] flatpak run dev.vencord.Vesktop"
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
          variables = ["--all"];
        };
      };
    };
  };
}

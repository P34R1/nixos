{
  config,
  pkgs,
  lib,
  inputs,
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
  '';

  inherit (lib.strings)
    concatMapStrings
    concatMapStringsSep
    optionalString
    toLower
    ;

  wms = [
    {
      command = "Hyprland";
      indicator = "h";
      enable = config.hyprland.enable;
    }
    # {
    #   command = "dwm";
    #   indicator = "d";
    #   enable = config.dwm.enable;
    # }
  ];

  # \033[1m => bold        \033[0m => unbold
  # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStrings
  enabledOptions = concatMapStrings (
    opt: optionalString opt.enable "\\033[1m[${opt.indicator}]\\033[0m - ${toLower opt.command}\\n"
  ) wms;

  # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStringsSep
  enabledCases = concatMapStringsSep "\n" (
    opt: optionalString opt.enable "${opt.indicator}) exec ${opt.command};;"
  ) wms;
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
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

      # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
      home.file.".bash_profile".text = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          printf "${enabledOptions}"

          stty -icanon -echo
          choice=$(dd bs=1 count=1 2>/dev/null)
          stty icanon echo

          case "$choice" in
            ${enabledCases}
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
          variables = [ "--all" ];
        };
      };
    };
  };
}

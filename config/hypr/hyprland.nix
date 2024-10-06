{ config, pkgs, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar & disown 
    ${pkgs.udiskie}/bin/udiskie &
    ${pkgs.dunst}/bin/dunst
  '';

  volume = pkgs.pkgs.writeShellScriptBin "volume" ./volume;
in
{
  imports = [
    ./waybar.nix
    ./visuals.nix
    ./workspaces.nix
    ./windowrules.nix
  ];

  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
  # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # My main moniter, max hz
      monitor = "HDMI-A-4, highrr, 0x0, 1";
      cursor.no_hardware_cursors = true;

      exec-once = [
        #"waybar"
        ''${startupScript}/bin/start''
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
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
#        "$mod, F, exec, firefox"
#        ", Print, exec, grimblast copy area"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause" # the stupid key is called play , but it toggles 
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioRaiseVolume, exec, ${volume} up"
        ", XF86AudioLowerVolume, exec, ${volume} down"
        ", XF86AudioMute, exec, ${volume} mute"
      ];
    };

    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };
}

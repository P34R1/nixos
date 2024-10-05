{ config, pkgs, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    #${pkgs.waybar}/bin/waybar & 
    ${pkgs.udiskie}/bin/udiskie &
  '';
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

      exec-once = "waybar";
      exec-once = ''${startupScript}/bin/start'';

      "$mod" = "SUPER";
      "$TERMINAL" = "foot";
      "$MENU" = "tofi-drun --drun-launch=true";

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
    };

    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };

#  programs.hyprlock.enable = true;
#  services.hypridle.enable = true;
}

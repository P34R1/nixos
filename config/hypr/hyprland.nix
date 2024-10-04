{ config, pkgs, ... }:


{
  imports = [
    ./waybar.nix
    ./visuals.nix
    ./workspaces.nix
  ];

  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
  # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      cursor.no_hardware_cursors = true;

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
#        "$mod, F, exec, firefox"
#        ", Print, exec, grimblast copy area"
      ];
    };
  };

#  programs.hyprlock.enable = true;
#  services.hypridle.enable = true;
}

{ config, pkgs, ... }:


{
  imports = [
    ./visuals.nix
  ];

#  programs.hyprland.enable = true;

  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
  # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      cursor.no_hardware_cursors = true;

      "$mod" = "SUPER";
      bind =
        [
#          "$mod, F, exec, firefox"
#          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let button = toString i;
              let workspace = if i == 0 then "10" else toString i;
              in [
                # Workspaces
                "$mod, ${button}, workspace, ${workspace}"
                # Move to workspace
                "$mod SHIFT, ${button}, movetoworkspace, ${workspace}"
              ]
            )
          10)
      );
    };
  };

#  programs.hyprlock.enable = true;
#  services.hypridle.enable = true;

#  environment.systemPackages = with pkgs; [
#    hyprpaper
#    waybar
#  ];
}

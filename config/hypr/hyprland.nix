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
              let ws = i + 1;
              in [
                # Workspaces
                "$mod, ${toString ws}, workspace, ${toString ws}"
                # Move to workspace
                "$mod SHIFT, ${toString ws}, movetoworkspace, ${toString ws}"
                "$mod, 0, workspace, 10"
                "$mod, 0, movetoworkspace, 10"
              ]
            )
            9)
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

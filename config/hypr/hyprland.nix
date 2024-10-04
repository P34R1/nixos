{ config, pkgs, ... }:


{
#  programs.hyprland.enable = true;

  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
  # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      cursor.no_hardware_cursors = true;

      general = with config.colorScheme.colors; {
        "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = "rgba(${base00}ff)";

        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
#        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
#        col.inactive_border = rgba(595959aa)

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

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

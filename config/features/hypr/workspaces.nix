{ config, pkgs, ... }:

{
  # binds $mod + [shift +] {1..9} to [move to] workspace {1..10}
  wayland.windowManager.hyprland.settings.bind = 
    builtins.concatLists (builtins.genList (i:
        let
          button = toString i;
          workspace = if i == 0 then "10" else toString i;
        in [
          # Workspaces
          "$mod, ${button}, workspace, ${workspace}"
          # Move to workspace
          "$mod SHIFT, ${button}, movetoworkspace, ${workspace}"
        ]
      )
    10);
}

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "tag +music, initialtitle:(Spotify)" # add dynamic tag `music*` to window spotify
      "workspace 3 silent, tag:music"

      "suppressevent maximize, class:.*" # You'll probably like this.
    ];

    workspace = [
      "special:scratchpad, on-created-empty:[float; size 700 1015; move 1200 42] foot"
    ];
  };
}

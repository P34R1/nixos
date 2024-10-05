{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "tag +music, initialtitle:(Spotify)" # add dynamic tag `music*` to window spotify
      "workspace 3, tag:music"
      "suppressevent maximize, class:.*" # You'll probably like this.
    ];
  };
}

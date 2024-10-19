{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "workspace 4 silent, class:vesktop"

      "suppressevent maximize, class:.*" # You'll probably like this.
    ];

    workspace = [
      "special:scratchpad, on-created-empty:[float; size 700 1015; move 1200 42] foot"
    ];
  };
}

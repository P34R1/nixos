{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "workspace 4 silent, class:vesktop"
      "workspace 4 silent, class:discord"
      "workspace special:scratchpad silent, title:App" # for bevy (i'll improve on this later)
      "workspace 5 silent, class:five" # for bevy (i'll improve on this later)

      "suppressevent maximize, class:.*" # You'll probably like this.
    ];

    workspace = [
      # "special:scratchpad, on-created-empty:[float; size 700 1015; move 1200 42] foot"
    ];
  };
}

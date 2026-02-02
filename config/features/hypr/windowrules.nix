{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "match:class vesktop, workspace 4 silent"
      "match:class discord, workspace 4"
      "match:title App, workspace special:scratchpad silent" # for bevy (i'll improve on this later)
      "match:class five, workspace 5 silent" # for bevy (i'll improve on this later)

      "match:class .*, suppress_event maximize" # You'll probably like this.
    ];

    workspace = [
      # "special:scratchpad, on-created-empty:[float; size 700 1015; move 1200 42] foot"
    ];
  };
}

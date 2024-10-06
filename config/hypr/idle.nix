{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.hypridle.enable
  services.hypridle = {
    enable = true;


    # https://github.com/ericmurphyxyz/dotfiles/blob/master/.config/hypr/hypridle.conf
    settings = {
      general = {
        before_sleep_cmd = "hyprlock";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 300; # 5min
          on-timeout = "hyprlock"; # lock screen when timeout has passed
        }
        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
      ];
    };
  };  
}

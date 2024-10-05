{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.displayManager = {
    enable = true;
    autoLogin = {
      enable = true;
      user = "pearl";
    };
    defaultSession = "hyprland";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    autoLogin.timeout = 0;
    greeter.enable = false;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
  ];
}

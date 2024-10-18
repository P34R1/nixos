{ config, pkgs, inputs, ... }:

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
    autoLogin.timeout = 10;
    #greeter.enable = false;
  };
}

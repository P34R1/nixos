{ config, pkgs, ... }:

{
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  services.flatpak.packages = [
    "dev.vencord.Vesktop"
    "com.obsproject.Studio"
    # "org.blender.Blender"
  ];
}

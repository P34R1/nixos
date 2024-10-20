{ config, pkgs, lib, ... }:

{
  options = {
    dunst.enable =
      lib.mkEnableOption "enable dunst";
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
  # https://mynixos.com/home-manager/options/services.dunst
  config = lib.mkIf config.dunst.enable {
    hm.services.dunst = {
      enable = true;

      # https://github.com/ericmurphyxyz/dotfiles/blob/master/.config/dunst/dunstrc
      configFile = ./dunstrc;
    };
  };
}

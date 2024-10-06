{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
  # https://mynixos.com/home-manager/options/services.dunst

  services.dunst = {
    enable = true;

    # https://github.com/ericmurphyxyz/dotfiles/blob/master/.config/dunst/dunstrc
    configFile = ./dunstrc;
  };
}

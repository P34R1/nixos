{ config, pkgs, ... }:

{
  # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.enable
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "${pkgs.fish}/bin/fish";
      };

      colors.alpha = 0.5;
    };
  };
}
